`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/16 23:24:16
// Design Name: 
// Module Name: mac_quad
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


module mac_quad
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
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_i, mac_acc_b_i, mac_acc_c_i, mac_acc_d_i,
  
  //mac activation out
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_a_o, mac_mantissa_activation_b_o, mac_mantissa_activation_c_o, mac_mantissa_activation_d_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_o, mac_acc_b_o, mac_acc_c_o, mac_acc_d_o,

  //Load Weight In/////////////////////////////////////////////////////////////////
  input   wire [7:0]                 i_load_weight_data_a_0,
  input   wire [7:0]                 i_load_weight_data_b_0,
  input   wire [7:0]                 i_load_weight_data_c_0,
  input   wire [7:0]                 i_load_weight_data_d_0,

  input   wire [7:0]                 i_load_weight_data_a_1,
  input   wire [7:0]                 i_load_weight_data_b_1,
  input   wire [7:0]                 i_load_weight_data_c_1,
  input   wire [7:0]                 i_load_weight_data_d_1,

  //Load Weight Out////////////////////////////////////////////////////////////////
  output  wire [7:0]                 o_load_weight_data_a_0,
  output  wire [7:0]                 o_load_weight_data_b_0,
  output  wire [7:0]                 o_load_weight_data_c_0,
  output  wire [7:0]                 o_load_weight_data_d_0,

  output  wire [7:0]                 o_load_weight_data_a_1,
  output  wire [7:0]                 o_load_weight_data_b_1,
  output  wire [7:0]                 o_load_weight_data_c_1,
  output  wire [7:0]                 o_load_weight_data_d_1
);
  
  mac_unit
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_unit_a
  (
    .clk(clk), 
    .rst_n(rst_n),
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .set_weight(set_weight_i),
    .mac_mantissa_activation_i(mac_mantissa_activation_a_i),
    .mac_acc_i(mac_acc_a_i),
    .mac_mantissa_activation_o(mac_mantissa_activation_a_o),
    .mac_acc_o(mac_acc_a_o),
    .i_load_weight_data_0(i_load_weight_data_a_0),
    .i_load_weight_data_1(i_load_weight_data_a_1),
    .o_load_weight_data_0(o_load_weight_data_a_0),
    .o_load_weight_data_1(o_load_weight_data_a_1)
  );
  
  mac_unit
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_unit_b
  (
    .clk(clk), 
    .rst_n(rst_n),
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .set_weight(set_weight_i),
    .mac_mantissa_activation_i(mac_mantissa_activation_b_i),
    .mac_acc_i(mac_acc_b_i),
    .mac_mantissa_activation_o(mac_mantissa_activation_b_o),
    .mac_acc_o(mac_acc_b_o),
    .i_load_weight_data_0(i_load_weight_data_b_0),
    .i_load_weight_data_1(i_load_weight_data_b_1),
    .o_load_weight_data_0(o_load_weight_data_b_0),
    .o_load_weight_data_1(o_load_weight_data_b_1)
  );

  mac_unit
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_unit_c
  (
    .clk(clk), 
    .rst_n(rst_n),
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .set_weight(set_weight_i),
    .mac_mantissa_activation_i(mac_mantissa_activation_c_i),
    .mac_acc_i(mac_acc_c_i),
    .mac_mantissa_activation_o(mac_mantissa_activation_c_o),
    .mac_acc_o(mac_acc_c_o),
    .i_load_weight_data_0(i_load_weight_data_c_0),
    .i_load_weight_data_1(i_load_weight_data_c_1),
    .o_load_weight_data_0(o_load_weight_data_c_0),
    .o_load_weight_data_1(o_load_weight_data_c_1)
  );

  mac_unit
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_unit_d
  (
    .clk(clk), 
    .rst_n(rst_n),
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .set_weight(set_weight_i),
    .mac_mantissa_activation_i(mac_mantissa_activation_d_i),
    .mac_acc_i(mac_acc_d_i),
    .mac_mantissa_activation_o(mac_mantissa_activation_d_o),
    .mac_acc_o(mac_acc_d_o),
    .i_load_weight_data_0(i_load_weight_data_d_0),
    .i_load_weight_data_1(i_load_weight_data_d_1),
    .o_load_weight_data_0(o_load_weight_data_d_0),
    .o_load_weight_data_1(o_load_weight_data_d_1)
  );
endmodule
