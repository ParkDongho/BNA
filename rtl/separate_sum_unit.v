`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/18 23:03:01
// Design Name: 
// Module Name: separate_sum_unit
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


module separate_sum_unit
#(
  parameter WEIGHT_RAM_ADDR_WIDTH = 4,
  parameter MAC_ACC_WIDTH = 48,
  parameter EXPONENT_WIDTH = 8
)
(
  input  wire clk, rst_n,
  
  //Write Buffer Control
  input  wire prepare_weight,
  //input  wire i_weight_data_fifo_wr_en,
  
  //Execute Control
  input  wire set_weight_i,
  
  input  wire [EXPONENT_WIDTH-1:0] mac_exponent_activation_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_i, mac_acc_b_i, mac_acc_c_i, mac_acc_d_i,
  
  output reg  [EXPONENT_WIDTH-1:0] mac_exponent_activation_o,
    
  output reg [32-1:0] mac_acc_result_a_o, mac_acc_result_b_o,

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
  output  reg  [7:0]                 o_load_weight_data_a_0,
  output  reg  [7:0]                 o_load_weight_data_b_0,
  output  reg  [7:0]                 o_load_weight_data_c_0,
  output  reg  [7:0]                 o_load_weight_data_d_0,

  output  reg  [7:0]                 o_load_weight_data_a_1,
  output  reg  [7:0]                 o_load_weight_data_b_1,
  output  reg  [7:0]                 o_load_weight_data_c_1,
  output  reg  [7:0]                 o_load_weight_data_d_1
);


  // siganl declaration
  reg  [EXPONENT_WIDTH-1:0] tmp_weight_a_ram, tmp_weight_b_ram;
  /*(* use_dsp48 = "yes" *) */reg  [MAC_ACC_WIDTH-1:0] mac_acc_sum_ab, mac_acc_sum_cd;
  /*(* use_dsp48 = "yes" *) */reg  [MAC_ACC_WIDTH-1:0] mac_acc_sum_abcd;

  reg [7:0] fifo_data_out_0, fifo_data_out_1; 
  
  // body
  // alu & activation register
  always @(posedge clk) 
  begin
    mac_acc_sum_ab <= {{7{mac_acc_a_i[33]}}, mac_acc_a_i[33:17], {7{mac_acc_a_i[16]}}, mac_acc_a_i[16:0]} + {{7{mac_acc_b_i[33]}}, mac_acc_b_i[33:17], {7{mac_acc_b_i[16]}}, mac_acc_b_i[16:0]}; //stage 0
    mac_acc_sum_cd <= {{7{mac_acc_c_i[33]}}, mac_acc_c_i[33:17], {7{mac_acc_c_i[16]}}, mac_acc_c_i[16:0]} + {{7{mac_acc_d_i[33]}}, mac_acc_d_i[33:17], {7{mac_acc_d_i[16]}}, mac_acc_d_i[16:0]}; //stage 0
    mac_exponent_activation_o <= mac_exponent_activation_i; //stage 0

    mac_acc_sum_abcd <= mac_acc_sum_ab + mac_acc_sum_cd; //stage 1

    mac_acc_result_a_o[23:0] <= mac_acc_sum_abcd[23:0]; //stage 2
    mac_acc_result_b_o[23:0] <= mac_acc_sum_abcd[47:24] + mac_acc_sum_abcd[23]; //stage 2
    mac_acc_result_a_o[31:24] <= mac_exponent_activation_i + fifo_data_out_0; //stage 2
    mac_acc_result_b_o[31:24] <= mac_exponent_activation_i + fifo_data_out_1; //stage 2
  
    if (prepare_weight) 
    begin
      o_load_weight_data_a_0 <= i_load_weight_data_a_0;
      o_load_weight_data_b_0 <= i_load_weight_data_b_0;
      o_load_weight_data_c_0 <= i_load_weight_data_c_0;
      o_load_weight_data_d_0 <= i_load_weight_data_d_0;
      o_load_weight_data_a_1 <= i_load_weight_data_a_1;
      o_load_weight_data_b_1 <= i_load_weight_data_b_1;
      o_load_weight_data_c_1 <= i_load_weight_data_c_1;
      o_load_weight_data_d_1 <= i_load_weight_data_d_1;
    end
    
    if (set_weight_i)
    begin
      fifo_data_out_0 <= o_load_weight_data_a_0;
      fifo_data_out_1 <= o_load_weight_data_a_1;
    end
  end
  
/*
  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(8*2),
    .REG_OUT("yes")
  ) weight_exponent_data_fifo(
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(set_weight_i), 
    .wr_en(i_weight_data_fifo_wr_en),
    .data_in({o_load_weight_data_a_0, o_load_weight_data_a_1}),
    .fifo_empty(), 
    .fifo_full(),
    .data_out({fifo_data_out_0, fifo_data_out_1})
  );*/
  
endmodule