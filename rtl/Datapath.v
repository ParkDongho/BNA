`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/23 00:25:08
// Design Name: 
// Module Name: Datapath
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


module Datapath
#(
  parameter                               QUNATIZED_MANTISSA_WIDTH = 7,
  parameter                               EXPONENT_WIDTH = 8,

  parameter                               AXI_WIDTH_USER =1,              // Master ID
  parameter                               AXI_WIDTH_ID   =4,              // ID width in bits
  parameter                               AXI_WIDTH_AD   =32,             // address width
  parameter                               AXI_WIDTH_DA   =32,             // data width
  parameter                               AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter                               AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter                               AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter                               AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  
  //Excute
  parameter                               MAC_ACC_WIDTH = 48,
  parameter                               BUFFER_ADDR_WIDTH = 15,
  
  parameter                               ACCUM_DATA_WIDTH = 32,
  parameter                               ACCUM_ADDR_WIDTH = 8,
  parameter                               BIAS_ROM_ADDR = 8,
  
  //Activation
  parameter                               PARAM_ROM_ADDR_WIDTH = 8
  
  //Store
  

)
(
  input wire clk, rst_n,

  //Datapath Control Signals//////////////////////////////////////////////////
  //Load Contorl Signals///////////////////////////////////////////////////////
  //activation weight buffer control
  input  wire                            i_buffer_wr_en, //buffer write enable
  input  wire [BUFFER_ADDR_WIDTH-1:0]    i_buffer_wr_addr, //buffer write 
  ////////////////////
  //load control
  input  wire                            i_load_data_reg_wr_en, //OOO
  input  wire [2:0]                      i_sel_load_data,//axi master read data path control //OOO
  /////////////////////
  //write back control
  input  wire                            i_sel_wb, //OOO
  /////////////////////

  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals////////////////////////////////////////////////
  input  wire                            i_prepare_weight, //OOO
  input  wire                            i_load_weight_data_reg_wr_en,
  input  wire [4:0]                      i_sel_load_weight_data,  
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //Excute Control Signals/////////////////////////////////////////////////////
  //activation buffer control
  input  wire                            i_activation_rd_en, //activation buffer read enable //OOO
  input  wire [BUFFER_ADDR_WIDTH-1:0]    i_buffer_rd_addr, //buffer address //OOO
  ////////////////////////
  //systolic array control
  input  wire                            i_set_weight, //set prepared weight
  //input  wire                            i_weight_data_fifo_wr_en,
  /////////////////////
  //accumulator control
  input  wire                            i_bias_mode,
  input  wire                            i_set_bias,
  input  wire                            i_bias_data_fifo_wr_en,
  input  wire                            i_accum_rd_en, 
  input  wire                            i_accum_wr_en,
  input  wire [ACCUM_ADDR_WIDTH-1:0]     i_accum_addr, 
  //////////////////////////
  //accumulator fifo control
  output wire                            o_execute_out_fifo_full, //final data
  input  wire                            i_execute_out_fifo_wr_en, //final data
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //Activation Control Signals/////////////////////////////////////////////////
  //alu control 
  input  wire [3:0]                      vetor_unit_op,
  input  wire                            i_set_param,
  input  wire                            i_param_data_fifo_wr_en,
  ////////////////////////////
  //execute final fifo control
  output wire                            o_execute_out_fifo_empty, 
  input  wire                            i_execute_out_fifo_rd_en,
  ///////////////////////////////
  //activation accum fifo control
  output wire                            o_activation_accum_fifo_empty, 
  output wire                            o_activation_accum_fifo_full,
  input  wire                            i_activation_accum_fifo_rd_en, 
  input  wire                            i_activation_accum_fifo_wr_en,
  ///////////////////////////////
  //activation final fifo control
  output wire                            o_activation_out_fifo_full,
  input  wire                            i_activation_out_fifo_wr_en,
  ////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////  
  //Store Control Signals/////////////////////////////////////////////////////
  output wire                            o_activation_out_fifo_empty,
  input  wire                            i_activation_out_fifo_rd_en,
  input  wire                            i_store_data_reg_wr_en,
  input  wire [4:0]                      i_sel_store_data,
  ////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
  //AXI Mster DATA////////////////////////////////////////////////////////////
  //AXI MASTER 
  output wire [AXI_WIDTH_DA-1:0]       m_axi_memory_bus_WDATA,
  input  wire [AXI_WIDTH_DA-1:0]       m_axi_memory_bus_RDATA,
  input  wire [AXI_WIDTH_DA-1:0]       m_axi_weight_memory_bus_RDATA
  ////////////////////////////////////////////////////////////////////////////
);

  //Load Weight Out/////////////////////////////////////////////////////////////////
  wire [7:0]                           load_weight_data_0_a_param;
  wire [7:0]                           load_weight_data_0_b_param;
  wire [7:0]                           load_weight_data_0_c_param;
  wire [7:0]                           load_weight_data_0_d_param;

  wire [7:0]                           load_weight_data_1_a_param;
  wire [7:0]                           load_weight_data_1_b_param;
  wire [7:0]                           load_weight_data_1_c_param;
  wire [7:0]                           load_weight_data_1_d_param;

  wire [7:0]                           load_weight_data_2_a_param;
  wire [7:0]                           load_weight_data_2_b_param;
  wire [7:0]                           load_weight_data_2_c_param;
  wire [7:0]                           load_weight_data_2_d_param;

  wire [7:0]                           load_weight_data_3_a_param;
  wire [7:0]                           load_weight_data_3_b_param;
  wire [7:0]                           load_weight_data_3_c_param;
  wire [7:0]                           load_weight_data_3_d_param;

  wire [7:0]                           load_weight_data_4_a_param;
  wire [7:0]                           load_weight_data_4_b_param;
  wire [7:0]                           load_weight_data_4_c_param;
  wire [7:0]                           load_weight_data_4_d_param;

  wire [7:0]                           load_weight_data_5_a_param;
  wire [7:0]                           load_weight_data_5_b_param;
  wire [7:0]                           load_weight_data_5_c_param;
  wire [7:0]                           load_weight_data_5_d_param;

  wire [7:0]                           load_weight_data_6_a_param;
  wire [7:0]                           load_weight_data_6_b_param;
  wire [7:0]                           load_weight_data_6_c_param;
  wire [7:0]                           load_weight_data_6_d_param;

  wire [7:0]                           load_weight_data_7_a_param;
  wire [7:0]                           load_weight_data_7_b_param;
  wire [7:0]                           load_weight_data_7_c_param;
  wire [7:0]                           load_weight_data_7_d_param;

  wire [7:0]                           load_weight_data_8_a_param;
  wire [7:0]                           load_weight_data_8_b_param;
  wire [7:0]                           load_weight_data_8_c_param;
  wire [7:0]                           load_weight_data_8_d_param;

  wire [7:0]                           load_weight_data_9_a_param;
  wire [7:0]                           load_weight_data_9_b_param;
  wire [7:0]                           load_weight_data_9_c_param;
  wire [7:0]                           load_weight_data_9_d_param;

  wire [7:0]                           load_weight_data_10_a_param;
  wire [7:0]                           load_weight_data_10_b_param;
  wire [7:0]                           load_weight_data_10_c_param;
  wire [7:0]                           load_weight_data_10_d_param;

  wire [7:0]                           load_weight_data_11_a_param;
  wire [7:0]                           load_weight_data_11_b_param;
  wire [7:0]                           load_weight_data_11_c_param;
  wire [7:0]                           load_weight_data_11_d_param;

  wire [7:0]                           load_weight_data_12_a_param;
  wire [7:0]                           load_weight_data_12_b_param;
  wire [7:0]                           load_weight_data_12_c_param;
  wire [7:0]                           load_weight_data_12_d_param;

  wire [7:0]                           load_weight_data_13_a_param;
  wire [7:0]                           load_weight_data_13_b_param;
  wire [7:0]                           load_weight_data_13_c_param;
  wire [7:0]                           load_weight_data_13_d_param;

  wire [7:0]                           load_weight_data_14_a_param;
  wire [7:0]                           load_weight_data_14_b_param;
  wire [7:0]                           load_weight_data_14_c_param;
  wire [7:0]                           load_weight_data_14_d_param;

  wire [7:0]                           load_weight_data_15_a_param;
  wire [7:0]                           load_weight_data_15_b_param;
  wire [7:0]                           load_weight_data_15_c_param;
  wire [7:0]                           load_weight_data_15_d_param;

  wire [7:0]                           load_weight_data_16_a_param;
  wire [7:0]                           load_weight_data_16_b_param;
  wire [7:0]                           load_weight_data_16_c_param;
  wire [7:0]                           load_weight_data_16_d_param;

  wire [7:0]                           load_weight_data_17_a_param;
  wire [7:0]                           load_weight_data_17_b_param;
  wire [7:0]                           load_weight_data_17_c_param;
  wire [7:0]                           load_weight_data_17_d_param;

  wire [7:0]                           load_weight_data_18_a_param;
  wire [7:0]                           load_weight_data_18_b_param;
  wire [7:0]                           load_weight_data_18_c_param;
  wire [7:0]                           load_weight_data_18_d_param;

  wire [7:0]                           load_weight_data_19_a_param;
  wire [7:0]                           load_weight_data_19_b_param;
  wire [7:0]                           load_weight_data_19_c_param;
  wire [7:0]                           load_weight_data_19_d_param;

  wire [7:0]                           load_weight_data_20_a_param;
  wire [7:0]                           load_weight_data_20_b_param;
  wire [7:0]                           load_weight_data_20_c_param;
  wire [7:0]                           load_weight_data_20_d_param;

  wire [7:0]                           load_weight_data_21_a_param;
  wire [7:0]                           load_weight_data_21_b_param;
  wire [7:0]                           load_weight_data_21_c_param;
  wire [7:0]                           load_weight_data_21_d_param;

  wire [7:0]                           load_weight_data_22_a_param;
  wire [7:0]                           load_weight_data_22_b_param;
  wire [7:0]                           load_weight_data_22_c_param;
  wire [7:0]                           load_weight_data_22_d_param;

  wire [7:0]                           load_weight_data_23_a_param;
  wire [7:0]                           load_weight_data_23_b_param;
  wire [7:0]                           load_weight_data_23_c_param;
  wire [7:0]                           load_weight_data_23_d_param;

  wire [7:0]                           load_weight_data_24_a_param;
  wire [7:0]                           load_weight_data_24_b_param;
  wire [7:0]                           load_weight_data_24_c_param;
  wire [7:0]                           load_weight_data_24_d_param;

  wire [7:0]                           load_weight_data_25_a_param;
  wire [7:0]                           load_weight_data_25_b_param;
  wire [7:0]                           load_weight_data_25_c_param;
  wire [7:0]                           load_weight_data_25_d_param;

  wire [7:0]                           load_weight_data_26_a_param;
  wire [7:0]                           load_weight_data_26_b_param;
  wire [7:0]                           load_weight_data_26_c_param;
  wire [7:0]                           load_weight_data_26_d_param;

  wire [7:0]                           load_weight_data_27_a_param;
  wire [7:0]                           load_weight_data_27_b_param;
  wire [7:0]                           load_weight_data_27_c_param;
  wire [7:0]                           load_weight_data_27_d_param;

  wire [7:0]                           load_weight_data_28_a_param;
  wire [7:0]                           load_weight_data_28_b_param;
  wire [7:0]                           load_weight_data_28_c_param;
  wire [7:0]                           load_weight_data_28_d_param;

  wire [7:0]                           load_weight_data_29_a_param;
  wire [7:0]                           load_weight_data_29_b_param;
  wire [7:0]                           load_weight_data_29_c_param;
  wire [7:0]                           load_weight_data_29_d_param;

  wire [7:0]                           load_weight_data_30_a_param;
  wire [7:0]                           load_weight_data_30_b_param;
  wire [7:0]                           load_weight_data_30_c_param;
  wire [7:0]                           load_weight_data_30_d_param;

  wire [7:0]                           load_weight_data_31_a_param;
  wire [7:0]                           load_weight_data_31_b_param;
  wire [7:0]                           load_weight_data_31_c_param;
  wire [7:0]                           load_weight_data_31_d_param;

//Load out
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
  load_mantissa_0_o,  
  load_mantissa_1_o,  
  load_mantissa_2_o,  
  load_mantissa_3_o,
  load_mantissa_4_o,  
  load_mantissa_5_o,  
  load_mantissa_6_o,  
  load_mantissa_7_o,
  load_mantissa_8_o,  
  load_mantissa_9_o,  
  load_mantissa_10_o, 
  load_mantissa_11_o,
  load_mantissa_12_o, 
  load_mantissa_13_o, 
  load_mantissa_14_o, 
  load_mantissa_15_o,
  load_mantissa_16_o, 
  load_mantissa_17_o, 
  load_mantissa_18_o, 
  load_mantissa_19_o,
  load_mantissa_20_o, 
  load_mantissa_21_o, 
  load_mantissa_22_o, 
  load_mantissa_23_o,
  load_mantissa_24_o, 
  load_mantissa_25_o, 
  load_mantissa_26_o, 
  load_mantissa_27_o,
  load_mantissa_28_o, 
  load_mantissa_29_o, 
  load_mantissa_30_o, 
  load_mantissa_31_o;
  wire [EXPONENT_WIDTH-1:0] load_exponent_o;

//Execute out
  wire [ACCUM_DATA_WIDTH-1:0] 
  accum_0_o,  
  accum_1_o,  
  accum_2_o,  
  accum_3_o,
  accum_4_o,  
  accum_5_o,  
  accum_6_o,  
  accum_7_o,
  accum_8_o,  
  accum_9_o,  
  accum_10_o, 
  accum_11_o, 
  accum_12_o, 
  accum_13_o, 
  accum_14_o, 
  accum_15_o,
  accum_16_o, 
  accum_17_o, 
  accum_18_o, 
  accum_19_o,
  accum_20_o, 
  accum_21_o, 
  accum_22_o, 
  accum_23_o,
  accum_24_o, 
  accum_25_o, 
  accum_26_o, 
  accum_27_o,
  accum_28_o, 
  accum_29_o, 
  accum_30_o, 
  accum_31_o;

//Activation out
  wire [ACCUM_DATA_WIDTH-1:0] 
  vector_0_o,  
  vector_1_o,  
  vector_2_o,  
  vector_3_o,
  vector_4_o,  
  vector_5_o,  
  vector_6_o,  
  vector_7_o,
  vector_8_o,  
  vector_9_o,  
  vector_10_o, 
  vector_11_o,
  vector_12_o, 
  vector_13_o, 
  vector_14_o, 
  vector_15_o,
  vector_16_o, 
  vector_17_o, 
  vector_18_o, 
  vector_19_o,
  vector_20_o, 
  vector_21_o, 
  vector_22_o, 
  vector_23_o,
  vector_24_o, 
  vector_25_o, 
  vector_26_o, 
  vector_27_o,
  vector_28_o, 
  vector_29_o, 
  vector_30_o, 
  vector_31_o;

//Store out
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
  wb_mantissa_0_o,  
  wb_mantissa_1_o,  
  wb_mantissa_2_o,  
  wb_mantissa_3_o,
  wb_mantissa_4_o,  
  wb_mantissa_5_o,  
  wb_mantissa_6_o,  
  wb_mantissa_7_o,
  wb_mantissa_8_o,  
  wb_mantissa_9_o,  
  wb_mantissa_10_o, 
  wb_mantissa_11_o,
  wb_mantissa_12_o, 
  wb_mantissa_13_o, 
  wb_mantissa_14_o, 
  wb_mantissa_15_o,
  wb_mantissa_16_o, 
  wb_mantissa_17_o, 
  wb_mantissa_18_o, 
  wb_mantissa_19_o,
  wb_mantissa_20_o, 
  wb_mantissa_21_o, 
  wb_mantissa_22_o, 
  wb_mantissa_23_o,
  wb_mantissa_24_o, 
  wb_mantissa_25_o, 
  wb_mantissa_26_o, 
  wb_mantissa_27_o,
  wb_mantissa_28_o, 
  wb_mantissa_29_o, 
  wb_mantissa_30_o, 
  wb_mantissa_31_o;
  wire [EXPONENT_WIDTH-1:0] wb_exponent_o;



//
  Load
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .AXI_WIDTH_USER(AXI_WIDTH_USER),              // Master ID
    .AXI_WIDTH_ID(AXI_WIDTH_ID),                  // ID width in bits
    .AXI_WIDTH_AD(AXI_WIDTH_AD),                  // address width
    .AXI_WIDTH_DA(AXI_WIDTH_DA),                  // data width
    .AXI_WIDTH_DS(AXI_WIDTH_DS),                  // data strobe width
    .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD),        // axi lite address width
    .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA),        // axi lite data width
    .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS)         // data strobe width
  ) Load
  (
    .clk(clk), .rst_n(rst_n),
    .load_data_reg_wr_en(i_load_data_reg_wr_en),
    .sel_load_data(i_sel_load_data),
    //AXI Master Read
    .m_axi_memory_bus_RDATA(m_axi_memory_bus_RDATA),

    //Load out
    .load_mantissa_0_o(load_mantissa_0_o),   
    .load_mantissa_1_o(load_mantissa_1_o),  
    .load_mantissa_2_o(load_mantissa_2_o),   
    .load_mantissa_3_o(load_mantissa_3_o),
    .load_mantissa_4_o(load_mantissa_4_o),   
    .load_mantissa_5_o(load_mantissa_5_o),  
    .load_mantissa_6_o(load_mantissa_6_o),   
    .load_mantissa_7_o(load_mantissa_7_o),
    .load_mantissa_8_o(load_mantissa_8_o),   
    .load_mantissa_9_o(load_mantissa_9_o),  
    .load_mantissa_10_o(load_mantissa_10_o), 
    .load_mantissa_11_o(load_mantissa_11_o),
    .load_mantissa_12_o(load_mantissa_12_o), 
    .load_mantissa_13_o(load_mantissa_13_o), 
    .load_mantissa_14_o(load_mantissa_14_o), 
    .load_mantissa_15_o(load_mantissa_15_o),
    .load_mantissa_16_o(load_mantissa_16_o), 
    .load_mantissa_17_o(load_mantissa_17_o), 
    .load_mantissa_18_o(load_mantissa_18_o), 
    .load_mantissa_19_o(load_mantissa_19_o),
    .load_mantissa_20_o(load_mantissa_20_o), 
    .load_mantissa_21_o(load_mantissa_21_o), 
    .load_mantissa_22_o(load_mantissa_22_o), 
    .load_mantissa_23_o(load_mantissa_23_o),
    .load_mantissa_24_o(load_mantissa_24_o), 
    .load_mantissa_25_o(load_mantissa_25_o), 
    .load_mantissa_26_o(load_mantissa_26_o), 
    .load_mantissa_27_o(load_mantissa_27_o),
    .load_mantissa_28_o(load_mantissa_28_o), 
    .load_mantissa_29_o(load_mantissa_29_o), 
    .load_mantissa_30_o(load_mantissa_30_o), 
    .load_mantissa_31_o(load_mantissa_31_o),
    .load_exponent_o(load_exponent_o)
  );

  Execute
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH),
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .ACCUM_ADDR_WIDTH(ACCUM_ADDR_WIDTH)
  ) Execute
  (
    .clk(clk), .rst_n(rst_n),
    //Control Signals
    //Write Buffer Control
    .buffer_wr_en_i(i_buffer_wr_en),
    .select_wb(i_sel_wb), 
    .buffer_wr_addr_i(i_buffer_wr_addr),

    //////////////////////////////////////////////////////////////////////////////////
    //Load Weight Control Signals/////////////////////////////////////////////////////
    //
    .i_load_weight_data_reg_wr_en(i_load_weight_data_reg_wr_en),          
    .i_sel_load_weight_data(i_sel_load_weight_data),
    .i_prepare_weight(i_prepare_weight),
    /////////////////
    //AXI MASTER READ
    //
    .m_axi_weight_memory_bus_RDATA(m_axi_weight_memory_bus_RDATA),
    //////////////////////////////////////////////////////////////////////////////////

    
    //Execute Control
    .set_weight_i(i_set_weight), 
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(i_activation_rd_en),
    .buffer_rd_addr_i(i_buffer_rd_addr),
    

    //Accumulator Control
    .accum_rd_en_i(i_accum_rd_en), 
    .accum_wr_en_i(i_accum_wr_en), 
    .bias_mode_i(i_bias_mode),
    .i_set_bias(i_set_bias),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .accum_addr_i(i_accum_addr),

    //Accumulator FIFO Control
    .o_execute_out_fifo_full(o_execute_out_fifo_full), //final data
    .i_execute_out_fifo_wr_en(i_execute_out_fifo_wr_en), //final data
    .o_execute_out_fifo_empty(o_execute_out_fifo_empty), //to activation control
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en), //to activation control
    
    //Load Data(AXI Master Read)
    .execute_load_data_0_i(load_mantissa_0_o),  
    .execute_load_data_1_i(load_mantissa_1_o),
    .execute_load_data_2_i(load_mantissa_2_o),  
    .execute_load_data_3_i(load_mantissa_3_o),
    .execute_load_data_4_i(load_mantissa_4_o),  
    .execute_load_data_5_i(load_mantissa_5_o),
    .execute_load_data_6_i(load_mantissa_6_o),  
    .execute_load_data_7_i(load_mantissa_7_o),
    .execute_load_data_8_i(load_mantissa_8_o),  
    .execute_load_data_9_i(load_mantissa_9_o),
    .execute_load_data_10_i(load_mantissa_10_o), 
    .execute_load_data_11_i(load_mantissa_11_o),
    .execute_load_data_12_i(load_mantissa_12_o), 
    .execute_load_data_13_i(load_mantissa_13_o),
    .execute_load_data_14_i(load_mantissa_14_o), 
    .execute_load_data_15_i(load_mantissa_15_o),
    .execute_load_data_16_i(load_mantissa_16_o), 
    .execute_load_data_17_i(load_mantissa_17_o),
    .execute_load_data_18_i(load_mantissa_18_o), 
    .execute_load_data_19_i(load_mantissa_19_o),
    .execute_load_data_20_i(load_mantissa_20_o), 
    .execute_load_data_21_i(load_mantissa_21_o),
    .execute_load_data_22_i(load_mantissa_22_o), 
    .execute_load_data_23_i(load_mantissa_23_o),
    .execute_load_data_24_i(load_mantissa_24_o), 
    .execute_load_data_25_i(load_mantissa_25_o),
    .execute_load_data_26_i(load_mantissa_26_o), 
    .execute_load_data_27_i(load_mantissa_27_o),
    .execute_load_data_28_i(load_mantissa_28_o), 
    .execute_load_data_29_i(load_mantissa_29_o),
    .execute_load_data_30_i(load_mantissa_30_o), 
    .execute_load_data_31_i(load_mantissa_31_o),
    .load_exponent_i(load_exponent_o),

    //Write Back Data
    .execute_write_back_data_0_i(wb_mantissa_0_o),  
    .execute_write_back_data_1_i(wb_mantissa_1_o),
    .execute_write_back_data_2_i(wb_mantissa_2_o),  
    .execute_write_back_data_3_i(wb_mantissa_3_o),
    .execute_write_back_data_4_i(wb_mantissa_4_o),  
    .execute_write_back_data_5_i(wb_mantissa_5_o),
    .execute_write_back_data_6_i(wb_mantissa_6_o),  
    .execute_write_back_data_7_i(wb_mantissa_7_o),
    .execute_write_back_data_8_i(wb_mantissa_8_o),  
    .execute_write_back_data_9_i(wb_mantissa_9_o),
    .execute_write_back_data_10_i(wb_mantissa_10_o), 
    .execute_write_back_data_11_i(wb_mantissa_11_o),
    .execute_write_back_data_12_i(wb_mantissa_12_o), 
    .execute_write_back_data_13_i(wb_mantissa_13_o),
    .execute_write_back_data_14_i(wb_mantissa_14_o), 
    .execute_write_back_data_15_i(wb_mantissa_15_o),
    .execute_write_back_data_16_i(wb_mantissa_16_o), 
    .execute_write_back_data_17_i(wb_mantissa_17_o),
    .execute_write_back_data_18_i(wb_mantissa_18_o), 
    .execute_write_back_data_19_i(wb_mantissa_19_o),
    .execute_write_back_data_20_i(wb_mantissa_20_o), 
    .execute_write_back_data_21_i(wb_mantissa_21_o),
    .execute_write_back_data_22_i(wb_mantissa_22_o), 
    .execute_write_back_data_23_i(wb_mantissa_23_o),
    .execute_write_back_data_24_i(wb_mantissa_24_o), 
    .execute_write_back_data_25_i(wb_mantissa_25_o),
    .execute_write_back_data_26_i(wb_mantissa_26_o), 
    .execute_write_back_data_27_i(wb_mantissa_27_o),
    .execute_write_back_data_28_i(wb_mantissa_28_o), 
    .execute_write_back_data_29_i(wb_mantissa_29_o),
    .execute_write_back_data_30_i(wb_mantissa_30_o), 
    .execute_write_back_data_31_i(wb_mantissa_31_o),
    .write_back_exponent_i(wb_exponent_o),
    
    //Accumulator
    //Data
    .accum_0_o(accum_0_o),   
    .accum_1_o(accum_1_o),   
    .accum_2_o(accum_2_o),   
    .accum_3_o(accum_3_o),
    .accum_4_o(accum_4_o),   
    .accum_5_o(accum_5_o),   
    .accum_6_o(accum_6_o),   
    .accum_7_o(accum_7_o),
    .accum_8_o(accum_8_o),   
    .accum_9_o(accum_9_o),   
    .accum_10_o(accum_10_o), 
    .accum_11_o(accum_11_o),
    .accum_12_o(accum_12_o), 
    .accum_13_o(accum_13_o), 
    .accum_14_o(accum_14_o), 
    .accum_15_o(accum_15_o),
    .accum_16_o(accum_16_o), 
    .accum_17_o(accum_17_o), 
    .accum_18_o(accum_18_o), 
    .accum_19_o(accum_19_o),
    .accum_20_o(accum_20_o), 
    .accum_21_o(accum_21_o), 
    .accum_22_o(accum_22_o), 
    .accum_23_o(accum_23_o),
    .accum_24_o(accum_24_o), 
    .accum_25_o(accum_25_o), 
    .accum_26_o(accum_26_o), 
    .accum_27_o(accum_27_o),
    .accum_28_o(accum_28_o), 
    .accum_29_o(accum_29_o), 
    .accum_30_o(accum_30_o), 
    .accum_31_o(accum_31_o),


    ////////////////////////////////////////////////////////////////////////////
    //Load Weight Out///////////////////////////////////////////////////////////
    .o_load_weight_data_0_a_param(load_weight_data_0_a_param),
    .o_load_weight_data_0_b_param(load_weight_data_0_b_param),
    .o_load_weight_data_0_c_param(load_weight_data_0_c_param),
    .o_load_weight_data_0_d_param(load_weight_data_0_d_param),

    .o_load_weight_data_1_a_param(load_weight_data_1_a_param),
    .o_load_weight_data_1_b_param(load_weight_data_1_b_param),
    .o_load_weight_data_1_c_param(load_weight_data_1_c_param),
    .o_load_weight_data_1_d_param(load_weight_data_1_d_param),

    .o_load_weight_data_2_a_param(load_weight_data_2_a_param),
    .o_load_weight_data_2_b_param(load_weight_data_2_b_param),
    .o_load_weight_data_2_c_param(load_weight_data_2_c_param),
    .o_load_weight_data_2_d_param(load_weight_data_2_d_param),

    .o_load_weight_data_3_a_param(load_weight_data_3_a_param),
    .o_load_weight_data_3_b_param(load_weight_data_3_b_param),
    .o_load_weight_data_3_c_param(load_weight_data_3_c_param),
    .o_load_weight_data_3_d_param(load_weight_data_3_d_param),

    .o_load_weight_data_4_a_param(load_weight_data_4_a_param),
    .o_load_weight_data_4_b_param(load_weight_data_4_b_param),
    .o_load_weight_data_4_c_param(load_weight_data_4_c_param),
    .o_load_weight_data_4_d_param(load_weight_data_4_d_param),

    .o_load_weight_data_5_a_param(load_weight_data_5_a_param),
    .o_load_weight_data_5_b_param(load_weight_data_5_b_param),
    .o_load_weight_data_5_c_param(load_weight_data_5_c_param),
    .o_load_weight_data_5_d_param(load_weight_data_5_d_param),

    .o_load_weight_data_6_a_param(load_weight_data_6_a_param),
    .o_load_weight_data_6_b_param(load_weight_data_6_b_param),
    .o_load_weight_data_6_c_param(load_weight_data_6_c_param),
    .o_load_weight_data_6_d_param(load_weight_data_6_d_param),

    .o_load_weight_data_7_a_param(load_weight_data_7_a_param),
    .o_load_weight_data_7_b_param(load_weight_data_7_b_param),
    .o_load_weight_data_7_c_param(load_weight_data_7_c_param),
    .o_load_weight_data_7_d_param(load_weight_data_7_d_param),

    .o_load_weight_data_8_a_param(load_weight_data_8_a_param),
    .o_load_weight_data_8_b_param(load_weight_data_8_b_param),
    .o_load_weight_data_8_c_param(load_weight_data_8_c_param),
    .o_load_weight_data_8_d_param(load_weight_data_8_d_param),

    .o_load_weight_data_9_a_param(load_weight_data_9_a_param),
    .o_load_weight_data_9_b_param(load_weight_data_9_b_param),
    .o_load_weight_data_9_c_param(load_weight_data_9_c_param),
    .o_load_weight_data_9_d_param(load_weight_data_9_d_param),

    .o_load_weight_data_10_a_param(load_weight_data_10_a_param),
    .o_load_weight_data_10_b_param(load_weight_data_10_b_param),
    .o_load_weight_data_10_c_param(load_weight_data_10_c_param),
    .o_load_weight_data_10_d_param(load_weight_data_10_d_param),

    .o_load_weight_data_11_a_param(load_weight_data_11_a_param),
    .o_load_weight_data_11_b_param(load_weight_data_11_b_param),
    .o_load_weight_data_11_c_param(load_weight_data_11_c_param),
    .o_load_weight_data_11_d_param(load_weight_data_11_d_param),

    .o_load_weight_data_12_a_param(load_weight_data_12_a_param),
    .o_load_weight_data_12_b_param(load_weight_data_12_b_param),
    .o_load_weight_data_12_c_param(load_weight_data_12_c_param),
    .o_load_weight_data_12_d_param(load_weight_data_12_d_param),

    .o_load_weight_data_13_a_param(load_weight_data_13_a_param),
    .o_load_weight_data_13_b_param(load_weight_data_13_b_param),
    .o_load_weight_data_13_c_param(load_weight_data_13_c_param),
    .o_load_weight_data_13_d_param(load_weight_data_13_d_param),

    .o_load_weight_data_14_a_param(load_weight_data_14_a_param),
    .o_load_weight_data_14_b_param(load_weight_data_14_b_param),
    .o_load_weight_data_14_c_param(load_weight_data_14_c_param),
    .o_load_weight_data_14_d_param(load_weight_data_14_d_param),

    .o_load_weight_data_15_a_param(load_weight_data_15_a_param),
    .o_load_weight_data_15_b_param(load_weight_data_15_b_param),
    .o_load_weight_data_15_c_param(load_weight_data_15_c_param),
    .o_load_weight_data_15_d_param(load_weight_data_15_d_param),

    .o_load_weight_data_16_a_param(load_weight_data_16_a_param),
    .o_load_weight_data_16_b_param(load_weight_data_16_b_param),
    .o_load_weight_data_16_c_param(load_weight_data_16_c_param),
    .o_load_weight_data_16_d_param(load_weight_data_16_d_param),

    .o_load_weight_data_17_a_param(load_weight_data_17_a_param),
    .o_load_weight_data_17_b_param(load_weight_data_17_b_param),
    .o_load_weight_data_17_c_param(load_weight_data_17_c_param),
    .o_load_weight_data_17_d_param(load_weight_data_17_d_param),

    .o_load_weight_data_18_a_param(load_weight_data_18_a_param),
    .o_load_weight_data_18_b_param(load_weight_data_18_b_param),
    .o_load_weight_data_18_c_param(load_weight_data_18_c_param),
    .o_load_weight_data_18_d_param(load_weight_data_18_d_param),

    .o_load_weight_data_19_a_param(load_weight_data_19_a_param),
    .o_load_weight_data_19_b_param(load_weight_data_19_b_param),
    .o_load_weight_data_19_c_param(load_weight_data_19_c_param),
    .o_load_weight_data_19_d_param(load_weight_data_19_d_param),

    .o_load_weight_data_20_a_param(load_weight_data_20_a_param),
    .o_load_weight_data_20_b_param(load_weight_data_20_b_param),
    .o_load_weight_data_20_c_param(load_weight_data_20_c_param),
    .o_load_weight_data_20_d_param(load_weight_data_20_d_param),

    .o_load_weight_data_21_a_param(load_weight_data_21_a_param),
    .o_load_weight_data_21_b_param(load_weight_data_21_b_param),
    .o_load_weight_data_21_c_param(load_weight_data_21_c_param),
    .o_load_weight_data_21_d_param(load_weight_data_21_d_param),

    .o_load_weight_data_22_a_param(load_weight_data_22_a_param),
    .o_load_weight_data_22_b_param(load_weight_data_22_b_param),
    .o_load_weight_data_22_c_param(load_weight_data_22_c_param),
    .o_load_weight_data_22_d_param(load_weight_data_22_d_param),

    .o_load_weight_data_23_a_param(load_weight_data_23_a_param),
    .o_load_weight_data_23_b_param(load_weight_data_23_b_param),
    .o_load_weight_data_23_c_param(load_weight_data_23_c_param),
    .o_load_weight_data_23_d_param(load_weight_data_23_d_param),

    .o_load_weight_data_24_a_param(load_weight_data_24_a_param),
    .o_load_weight_data_24_b_param(load_weight_data_24_b_param),
    .o_load_weight_data_24_c_param(load_weight_data_24_c_param),
    .o_load_weight_data_24_d_param(load_weight_data_24_d_param),

    .o_load_weight_data_25_a_param(load_weight_data_25_a_param),
    .o_load_weight_data_25_b_param(load_weight_data_25_b_param),
    .o_load_weight_data_25_c_param(load_weight_data_25_c_param),
    .o_load_weight_data_25_d_param(load_weight_data_25_d_param),

    .o_load_weight_data_26_a_param(load_weight_data_26_a_param),
    .o_load_weight_data_26_b_param(load_weight_data_26_b_param),
    .o_load_weight_data_26_c_param(load_weight_data_26_c_param),
    .o_load_weight_data_26_d_param(load_weight_data_26_d_param),

    .o_load_weight_data_27_a_param(load_weight_data_27_a_param),
    .o_load_weight_data_27_b_param(load_weight_data_27_b_param),
    .o_load_weight_data_27_c_param(load_weight_data_27_c_param),
    .o_load_weight_data_27_d_param(load_weight_data_27_d_param),

    .o_load_weight_data_28_a_param(load_weight_data_28_a_param),
    .o_load_weight_data_28_b_param(load_weight_data_28_b_param),
    .o_load_weight_data_28_c_param(load_weight_data_28_c_param),
    .o_load_weight_data_28_d_param(load_weight_data_28_d_param),

    .o_load_weight_data_29_a_param(load_weight_data_29_a_param),
    .o_load_weight_data_29_b_param(load_weight_data_29_b_param),
    .o_load_weight_data_29_c_param(load_weight_data_29_c_param),
    .o_load_weight_data_29_d_param(load_weight_data_29_d_param),

    .o_load_weight_data_30_a_param(load_weight_data_30_a_param),
    .o_load_weight_data_30_b_param(load_weight_data_30_b_param),
    .o_load_weight_data_30_c_param(load_weight_data_30_c_param),
    .o_load_weight_data_30_d_param(load_weight_data_30_d_param),

    .o_load_weight_data_31_a_param(load_weight_data_31_a_param),
    .o_load_weight_data_31_b_param(load_weight_data_31_b_param),
    .o_load_weight_data_31_c_param(load_weight_data_31_c_param),
    .o_load_weight_data_31_d_param(load_weight_data_31_d_param)
    ////////////////////////////////////////////////////////////////////////////
  );

  Activation
  #(
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) Activation
  (
    .clk(clk), 
    .rst_n(rst_n),
    //Contorl Signal=============================================================
    //===========
    //alu control
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_set_param(i_set_param),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    //=============================
    //activation accum fifo control
    .o_activation_accum_fifo_empty(o_activation_accum_fifo_empty), 
    .o_activation_accum_fifo_full(o_activation_accum_fifo_full),
    .i_activation_accum_fifo_rd_en(i_activation_accum_fifo_rd_en), 
    .i_activation_accum_fifo_wr_en(i_activation_accum_fifo_wr_en),
    //=============================
    //activation final fifo control
    .o_activation_out_fifo_full(o_activation_out_fifo_full),
    .o_activation_out_fifo_empty(o_activation_out_fifo_empty),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    //==========================================================================
    
    .vector_0_i(accum_0_o),   
    .vector_1_i(accum_1_o),   
    .vector_2_i(accum_2_o),   
    .vector_3_i(accum_3_o),
    .vector_4_i(accum_4_o),   
    .vector_5_i(accum_5_o),   
    .vector_6_i(accum_6_o),   
    .vector_7_i(accum_7_o),
    .vector_8_i(accum_8_o),   
    .vector_9_i(accum_9_o),   
    .vector_10_i(accum_10_o), 
    .vector_11_i(accum_11_o),
    .vector_12_i(accum_12_o), 
    .vector_13_i(accum_13_o), 
    .vector_14_i(accum_14_o), 
    .vector_15_i(accum_15_o),
    .vector_16_i(accum_16_o), 
    .vector_17_i(accum_17_o), 
    .vector_18_i(accum_18_o), 
    .vector_19_i(accum_19_o),
    .vector_20_i(accum_20_o), 
    .vector_21_i(accum_21_o), 
    .vector_22_i(accum_22_o), 
    .vector_23_i(accum_23_o),
    .vector_24_i(accum_24_o), 
    .vector_25_i(accum_25_o), 
    .vector_26_i(accum_26_o), 
    .vector_27_i(accum_27_o),
    .vector_28_i(accum_28_o), 
    .vector_29_i(accum_29_o), 
    .vector_30_i(accum_30_o), 
    .vector_31_i(accum_31_o),

    .vector_0_o(vector_0_o),   
    .vector_1_o(vector_1_o),   
    .vector_2_o(vector_2_o),   
    .vector_3_o(vector_3_o),
    .vector_4_o(vector_4_o),   
    .vector_5_o(vector_5_o),   
    .vector_6_o(vector_6_o),   
    .vector_7_o(vector_7_o),
    .vector_8_o(vector_8_o),   
    .vector_9_o(vector_9_o),   
    .vector_10_o(vector_10_o), 
    .vector_11_o(vector_11_o),
    .vector_12_o(vector_12_o), 
    .vector_13_o(vector_13_o), 
    .vector_14_o(vector_14_o), 
    .vector_15_o(vector_15_o),
    .vector_16_o(vector_16_o), 
    .vector_17_o(vector_17_o), 
    .vector_18_o(vector_18_o), 
    .vector_19_o(vector_19_o),
    .vector_20_o(vector_20_o), 
    .vector_21_o(vector_21_o), 
    .vector_22_o(vector_22_o), 
    .vector_23_o(vector_23_o),
    .vector_24_o(vector_24_o), 
    .vector_25_o(vector_25_o), 
    .vector_26_o(vector_26_o), 
    .vector_27_o(vector_27_o),
    .vector_28_o(vector_28_o), 
    .vector_29_o(vector_29_o), 
    .vector_30_o(vector_30_o), 
    .vector_31_o(vector_31_o),

    ////////////////////////////////////////////////////////////////////////////
    //Load Weight In////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a_param(load_weight_data_0_a_param),
    .i_load_weight_data_0_b_param(load_weight_data_0_b_param),
    .i_load_weight_data_0_c_param(load_weight_data_0_c_param),
    .i_load_weight_data_0_d_param(load_weight_data_0_d_param),

    .i_load_weight_data_1_a_param(load_weight_data_1_a_param),
    .i_load_weight_data_1_b_param(load_weight_data_1_b_param),
    .i_load_weight_data_1_c_param(load_weight_data_1_c_param),
    .i_load_weight_data_1_d_param(load_weight_data_1_d_param),

    .i_load_weight_data_2_a_param(load_weight_data_2_a_param),
    .i_load_weight_data_2_b_param(load_weight_data_2_b_param),
    .i_load_weight_data_2_c_param(load_weight_data_2_c_param),
    .i_load_weight_data_2_d_param(load_weight_data_2_d_param),

    .i_load_weight_data_3_a_param(load_weight_data_3_a_param),
    .i_load_weight_data_3_b_param(load_weight_data_3_b_param),
    .i_load_weight_data_3_c_param(load_weight_data_3_c_param),
    .i_load_weight_data_3_d_param(load_weight_data_3_d_param),

    .i_load_weight_data_4_a_param(load_weight_data_4_a_param),
    .i_load_weight_data_4_b_param(load_weight_data_4_b_param),
    .i_load_weight_data_4_c_param(load_weight_data_4_c_param),
    .i_load_weight_data_4_d_param(load_weight_data_4_d_param),

    .i_load_weight_data_5_a_param(load_weight_data_5_a_param),
    .i_load_weight_data_5_b_param(load_weight_data_5_b_param),
    .i_load_weight_data_5_c_param(load_weight_data_5_c_param),
    .i_load_weight_data_5_d_param(load_weight_data_5_d_param),

    .i_load_weight_data_6_a_param(load_weight_data_6_a_param),
    .i_load_weight_data_6_b_param(load_weight_data_6_b_param),
    .i_load_weight_data_6_c_param(load_weight_data_6_c_param),
    .i_load_weight_data_6_d_param(load_weight_data_6_d_param),

    .i_load_weight_data_7_a_param(load_weight_data_7_a_param),
    .i_load_weight_data_7_b_param(load_weight_data_7_b_param),
    .i_load_weight_data_7_c_param(load_weight_data_7_c_param),
    .i_load_weight_data_7_d_param(load_weight_data_7_d_param),

    .i_load_weight_data_8_a_param(load_weight_data_8_a_param),
    .i_load_weight_data_8_b_param(load_weight_data_8_b_param),
    .i_load_weight_data_8_c_param(load_weight_data_8_c_param),
    .i_load_weight_data_8_d_param(load_weight_data_8_d_param),

    .i_load_weight_data_9_a_param(load_weight_data_9_a_param),
    .i_load_weight_data_9_b_param(load_weight_data_9_b_param),
    .i_load_weight_data_9_c_param(load_weight_data_9_c_param),
    .i_load_weight_data_9_d_param(load_weight_data_9_d_param),

    .i_load_weight_data_10_a_param(load_weight_data_10_a_param),
    .i_load_weight_data_10_b_param(load_weight_data_10_b_param),
    .i_load_weight_data_10_c_param(load_weight_data_10_c_param),
    .i_load_weight_data_10_d_param(load_weight_data_10_d_param),

    .i_load_weight_data_11_a_param(load_weight_data_11_a_param),
    .i_load_weight_data_11_b_param(load_weight_data_11_b_param),
    .i_load_weight_data_11_c_param(load_weight_data_11_c_param),
    .i_load_weight_data_11_d_param(load_weight_data_11_d_param),

    .i_load_weight_data_12_a_param(load_weight_data_12_a_param),
    .i_load_weight_data_12_b_param(load_weight_data_12_b_param),
    .i_load_weight_data_12_c_param(load_weight_data_12_c_param),
    .i_load_weight_data_12_d_param(load_weight_data_12_d_param),

    .i_load_weight_data_13_a_param(load_weight_data_13_a_param),
    .i_load_weight_data_13_b_param(load_weight_data_13_b_param),
    .i_load_weight_data_13_c_param(load_weight_data_13_c_param),
    .i_load_weight_data_13_d_param(load_weight_data_13_d_param),

    .i_load_weight_data_14_a_param(load_weight_data_14_a_param),
    .i_load_weight_data_14_b_param(load_weight_data_14_b_param),
    .i_load_weight_data_14_c_param(load_weight_data_14_c_param),
    .i_load_weight_data_14_d_param(load_weight_data_14_d_param),

    .i_load_weight_data_15_a_param(load_weight_data_15_a_param),
    .i_load_weight_data_15_b_param(load_weight_data_15_b_param),
    .i_load_weight_data_15_c_param(load_weight_data_15_c_param),
    .i_load_weight_data_15_d_param(load_weight_data_15_d_param),

    .i_load_weight_data_16_a_param(load_weight_data_16_a_param),
    .i_load_weight_data_16_b_param(load_weight_data_16_b_param),
    .i_load_weight_data_16_c_param(load_weight_data_16_c_param),
    .i_load_weight_data_16_d_param(load_weight_data_16_d_param),

    .i_load_weight_data_17_a_param(load_weight_data_17_a_param),
    .i_load_weight_data_17_b_param(load_weight_data_17_b_param),
    .i_load_weight_data_17_c_param(load_weight_data_17_c_param),
    .i_load_weight_data_17_d_param(load_weight_data_17_d_param),

    .i_load_weight_data_18_a_param(load_weight_data_18_a_param),
    .i_load_weight_data_18_b_param(load_weight_data_18_b_param),
    .i_load_weight_data_18_c_param(load_weight_data_18_c_param),
    .i_load_weight_data_18_d_param(load_weight_data_18_d_param),

    .i_load_weight_data_19_a_param(load_weight_data_19_a_param),
    .i_load_weight_data_19_b_param(load_weight_data_19_b_param),
    .i_load_weight_data_19_c_param(load_weight_data_19_c_param),
    .i_load_weight_data_19_d_param(load_weight_data_19_d_param),

    .i_load_weight_data_20_a_param(load_weight_data_20_a_param),
    .i_load_weight_data_20_b_param(load_weight_data_20_b_param),
    .i_load_weight_data_20_c_param(load_weight_data_20_c_param),
    .i_load_weight_data_20_d_param(load_weight_data_20_d_param),

    .i_load_weight_data_21_a_param(load_weight_data_21_a_param),
    .i_load_weight_data_21_b_param(load_weight_data_21_b_param),
    .i_load_weight_data_21_c_param(load_weight_data_21_c_param),
    .i_load_weight_data_21_d_param(load_weight_data_21_d_param),

    .i_load_weight_data_22_a_param(load_weight_data_22_a_param),
    .i_load_weight_data_22_b_param(load_weight_data_22_b_param),
    .i_load_weight_data_22_c_param(load_weight_data_22_c_param),
    .i_load_weight_data_22_d_param(load_weight_data_22_d_param),

    .i_load_weight_data_23_a_param(load_weight_data_23_a_param),
    .i_load_weight_data_23_b_param(load_weight_data_23_b_param),
    .i_load_weight_data_23_c_param(load_weight_data_23_c_param),
    .i_load_weight_data_23_d_param(load_weight_data_23_d_param),

    .i_load_weight_data_24_a_param(load_weight_data_24_a_param),
    .i_load_weight_data_24_b_param(load_weight_data_24_b_param),
    .i_load_weight_data_24_c_param(load_weight_data_24_c_param),
    .i_load_weight_data_24_d_param(load_weight_data_24_d_param),

    .i_load_weight_data_25_a_param(load_weight_data_25_a_param),
    .i_load_weight_data_25_b_param(load_weight_data_25_b_param),
    .i_load_weight_data_25_c_param(load_weight_data_25_c_param),
    .i_load_weight_data_25_d_param(load_weight_data_25_d_param),

    .i_load_weight_data_26_a_param(load_weight_data_26_a_param),
    .i_load_weight_data_26_b_param(load_weight_data_26_b_param),
    .i_load_weight_data_26_c_param(load_weight_data_26_c_param),
    .i_load_weight_data_26_d_param(load_weight_data_26_d_param),

    .i_load_weight_data_27_a_param(load_weight_data_27_a_param),
    .i_load_weight_data_27_b_param(load_weight_data_27_b_param),
    .i_load_weight_data_27_c_param(load_weight_data_27_c_param),
    .i_load_weight_data_27_d_param(load_weight_data_27_d_param),

    .i_load_weight_data_28_a_param(load_weight_data_28_a_param),
    .i_load_weight_data_28_b_param(load_weight_data_28_b_param),
    .i_load_weight_data_28_c_param(load_weight_data_28_c_param),
    .i_load_weight_data_28_d_param(load_weight_data_28_d_param),

    .i_load_weight_data_29_a_param(load_weight_data_29_a_param),
    .i_load_weight_data_29_b_param(load_weight_data_29_b_param),
    .i_load_weight_data_29_c_param(load_weight_data_29_c_param),
    .i_load_weight_data_29_d_param(load_weight_data_29_d_param),

    .i_load_weight_data_30_a_param(load_weight_data_30_a_param),
    .i_load_weight_data_30_b_param(load_weight_data_30_b_param),
    .i_load_weight_data_30_c_param(load_weight_data_30_c_param),
    .i_load_weight_data_30_d_param(load_weight_data_30_d_param),

    .i_load_weight_data_31_a_param(load_weight_data_31_a_param),
    .i_load_weight_data_31_b_param(load_weight_data_31_b_param),
    .i_load_weight_data_31_c_param(load_weight_data_31_c_param),
    .i_load_weight_data_31_d_param(load_weight_data_31_d_param)
    ///////////////////////////////////////////////////////////////////////
  );

  Store
  #(
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    
    .AXI_WIDTH_USER(AXI_WIDTH_USER),              // Master ID
    .AXI_WIDTH_ID(AXI_WIDTH_ID),                  // ID width in bits
    .AXI_WIDTH_AD(AXI_WIDTH_AD),                  // address width
    .AXI_WIDTH_DA(AXI_WIDTH_DA),                  // data width
    .AXI_WIDTH_DS(AXI_WIDTH_DS),                  // data strobe width
    .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD),        // axi lite address width
    .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA),        // axi lite data width
    .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS)         // data strobe width
  ) Store
  (
    .clk(clk), .rst_n(rst_n),
    .store_data_reg_wr_en(i_store_data_reg_wr_en),
    .sel_store_data(i_sel_store_data),
    
    .stor_0_i(vector_0_o),   
    .stor_1_i(vector_1_o),   
    .stor_2_i(vector_2_o),   
    .stor_3_i(vector_3_o),
    .stor_4_i(vector_4_o),   
    .stor_5_i(vector_5_o),   
    .stor_6_i(vector_6_o),   
    .stor_7_i(vector_7_o),
    .stor_8_i(vector_8_o),   
    .stor_9_i(vector_9_o),   
    .stor_10_i(vector_10_o), 
    .stor_11_i(vector_11_o),
    .stor_12_i(vector_12_o), 
    .stor_13_i(vector_13_o), 
    .stor_14_i(vector_14_o), 
    .stor_15_i(vector_15_o),
    .stor_16_i(vector_16_o), 
    .stor_17_i(vector_17_o), 
    .stor_18_i(vector_18_o), 
    .stor_19_i(vector_19_o),
    .stor_20_i(vector_20_o), 
    .stor_21_i(vector_21_o), 
    .stor_22_i(vector_22_o), 
    .stor_23_i(vector_23_o),
    .stor_24_i(vector_24_o), 
    .stor_25_i(vector_25_o), 
    .stor_26_i(vector_26_o), 
    .stor_27_i(vector_27_o),
    .stor_28_i(vector_28_o), 
    .stor_29_i(vector_29_o), 
    .stor_30_i(vector_30_o), 
    .stor_31_i(vector_31_o),
    
    //write back
    .wb_mantissa_0_o(wb_mantissa_0_o),   
    .wb_mantissa_1_o(wb_mantissa_1_o),  
    .wb_mantissa_2_o(wb_mantissa_2_o),   
    .wb_mantissa_3_o(wb_mantissa_3_o),
    .wb_mantissa_4_o(wb_mantissa_4_o),   
    .wb_mantissa_5_o(wb_mantissa_5_o),
    .wb_mantissa_6_o(wb_mantissa_6_o),   
    .wb_mantissa_7_o(wb_mantissa_7_o),
    .wb_mantissa_8_o(wb_mantissa_8_o),   
    .wb_mantissa_9_o(wb_mantissa_9_o),
    .wb_mantissa_10_o(wb_mantissa_10_o), 
    .wb_mantissa_11_o(wb_mantissa_11_o),
    .wb_mantissa_12_o(wb_mantissa_12_o), 
    .wb_mantissa_13_o(wb_mantissa_13_o),
    .wb_mantissa_14_o(wb_mantissa_14_o), 
    .wb_mantissa_15_o(wb_mantissa_15_o),
    .wb_mantissa_16_o(wb_mantissa_16_o), 
    .wb_mantissa_17_o(wb_mantissa_17_o),
    .wb_mantissa_18_o(wb_mantissa_18_o), 
    .wb_mantissa_19_o(wb_mantissa_19_o),
    .wb_mantissa_20_o(wb_mantissa_20_o), 
    .wb_mantissa_21_o(wb_mantissa_21_o),
    .wb_mantissa_22_o(wb_mantissa_22_o), 
    .wb_mantissa_23_o(wb_mantissa_23_o),
    .wb_mantissa_24_o(wb_mantissa_24_o), 
    .wb_mantissa_25_o(wb_mantissa_25_o),
    .wb_mantissa_26_o(wb_mantissa_26_o), 
    .wb_mantissa_27_o(wb_mantissa_27_o),
    .wb_mantissa_28_o(wb_mantissa_28_o), 
    .wb_mantissa_29_o(wb_mantissa_29_o),
    .wb_mantissa_30_o(wb_mantissa_30_o), 
    .wb_mantissa_31_o(wb_mantissa_31_o),
    .wb_exponent_o(wb_exponent_o),


    //axi master write
    .m_axi_memory_bus_WDATA(m_axi_memory_bus_WDATA)
  );
endmodule
