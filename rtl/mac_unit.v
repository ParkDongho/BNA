`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////\
// Engineer: Dongho Park
// 
// Create Date: 2021/02/17 00:24:49
// Design Name: 
// Module Name: mac_unit
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


module mac_unit
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter MAC_ACC_WIDTH = 47,
  parameter BUFFER_ADDR_WIDTH = 15
)
(
  input  wire                                       clk, 
  input  wire                                       rst_n,
  input  wire                                       prepare_weight, 
  //input  wire                                       i_weight_data_fifo_wr_en,
  input  wire                                       set_weight,
  input  wire signed [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_i,
  input  wire signed [MAC_ACC_WIDTH-1:0]            mac_acc_i,
  output reg  signed [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_o,
  output reg  signed [MAC_ACC_WIDTH-1:0]            mac_acc_o,

  //Load Weight/////////////////////////////////////////////////////////////////
  input  wire signed [7:0]                          i_load_weight_data_0,
  input  wire signed [7:0]                          i_load_weight_data_1,
  output reg  signed [7:0]                          o_load_weight_data_0,
  output reg  signed [7:0]                          o_load_weight_data_1
);


  // siganl declaration
  reg  signed [24:0]                                tmp_shift_result;
  reg  signed [31:0]                                tmp_mul_result;
  reg  signed [MAC_ACC_WIDTH-1:0]                   tmp_mac_acc;
  wire signed [QUNATIZED_MANTISSA_WIDTH-1:0]        fifo_data_out_0;
  wire signed [QUNATIZED_MANTISSA_WIDTH-1:0]        fifo_data_out_1;
  
  
  // body
  // alu & activation register
  always @(posedge clk) 
  begin
    tmp_mul_result <= tmp_shift_result * mac_mantissa_activation_i;
    mac_acc_o <= tmp_mac_acc + tmp_mul_result;
    mac_mantissa_activation_o <= mac_mantissa_activation_i; // activation register
    tmp_mac_acc <= mac_acc_i;

    if (set_weight)
    begin
      //tmp_shift_result <= fifo_data_out_0 + (fifo_data_out_1 << 17);
      tmp_shift_result <= o_load_weight_data_0[QUNATIZED_MANTISSA_WIDTH-1:0] + (o_load_weight_data_1[QUNATIZED_MANTISSA_WIDTH-1:0] << 17);
    end
  
    if (prepare_weight) 
    begin
      o_load_weight_data_0 <= i_load_weight_data_0;
      o_load_weight_data_1 <= i_load_weight_data_1;
    end
  end
/*
  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(QUNATIZED_MANTISSA_WIDTH*2),
    .REG_OUT("no")
  ) weight_data_fifo(
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(set_weight), 
    .wr_en(i_weight_data_fifo_wr_en),
    .data_in({o_load_weight_data_0[QUNATIZED_MANTISSA_WIDTH-1:0], o_load_weight_data_1[QUNATIZED_MANTISSA_WIDTH-1:0]}),
    .fifo_empty(), 
    .fifo_full(),
    .data_out({fifo_data_out_0, fifo_data_out_1})
  );
*/
endmodule