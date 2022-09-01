`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/17 04:27:07
// Design Name: 
// Module Name: mac_unit_noadder
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


module mac_unit_noadder
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter WEIGHT_RAM_ADDR_WIDTH = 4,
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15
)
(
  input  wire                                       clk, 
  input  wire                                       prepare_weight, 
  //input  wire                                       i_weight_data_fifo_wr_en,
  input  wire                                       set_weight,
  input  wire signed [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_i,
  output reg  signed [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_o,
  output reg  signed [MAC_ACC_WIDTH-1:0]            mac_acc_o,

  //Load Weight/////////////////////////////////////////////////////////////////
  input  wire signed [7:0]                          i_load_weight_data_0,
  input  wire signed [7:0]                          i_load_weight_data_1,
  output reg  signed [7:0]                          o_load_weight_data_0,
  output reg  signed [7:0]                          o_load_weight_data_1
);

  // siganl declaration
  reg  signed [24:0]                               tmp_shift_result;

  // body
  // alu & activation register
  always @(posedge clk) 
  begin
    mac_acc_o <= tmp_shift_result * mac_mantissa_activation_i; // multiplication
    mac_mantissa_activation_o <= mac_mantissa_activation_i; // activation register
    if (set_weight)
    begin
      tmp_shift_result <= o_load_weight_data_0[QUNATIZED_MANTISSA_WIDTH-1:0] + (o_load_weight_data_1[QUNATIZED_MANTISSA_WIDTH-1:0] << 17);
    end
    if (prepare_weight) 
    begin
      o_load_weight_data_0 <= i_load_weight_data_0;
      o_load_weight_data_1 <= i_load_weight_data_1;
    end
  end
/*
  // siganl declaration
  reg  signed [QUNATIZED_MANTISSA_WIDTH-1:0]       weight_0;
  reg  signed [QUNATIZED_MANTISSA_WIDTH-1:0]       weight_1;
  wire signed [QUNATIZED_MANTISSA_WIDTH*2-1:0]     aw0;
  wire signed [QUNATIZED_MANTISSA_WIDTH*2-1:0]     aw1;
  assign aw0 = mac_mantissa_activation_i*weight_0;
  assign aw1 = mac_mantissa_activation_i*weight_1;

  // body
  // alu & activation register
  always @(posedge clk) 
  begin
    mac_acc_o <= aw0 + (aw1<<17); // multiplication
    mac_mantissa_activation_o <= mac_mantissa_activation_i; // activation register
    if (set_weight)
    begin
      weight_0 <= o_load_weight_data_0[QUNATIZED_MANTISSA_WIDTH-1:0];
      weight_1 <= o_load_weight_data_1[QUNATIZED_MANTISSA_WIDTH-1:0];
    end
    if (prepare_weight) 
    begin
      o_load_weight_data_0 <= i_load_weight_data_0;
      o_load_weight_data_1 <= i_load_weight_data_1;
    end
  end
*/
endmodule