`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 22:59:33
// Design Name: 
// Module Name: accumulator_dual
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


module accumulator_dual
#(
  parameter ADDR_WIDTH = 8,
  parameter DATA_WIDTH = 32,
  parameter BIAS_ROM_ADDR = 8
)
(
  //input
  //control signals
  input  wire                          clk, 
  input  wire                          rst_n,
  
  input  wire                          rd_en_i, 
  input  wire                          wr_en_i, 
  input  wire                          bias_mode_i,
  input  wire                          i_prepare_weight,
  input  wire                          i_bias_data_fifo_wr_en,
  input  wire                          i_set_bias,

  input  wire [DATA_WIDTH-1:0]         data_in_0, 
  input  wire [DATA_WIDTH-1:0]         data_in_1,

  input  wire [ADDR_WIDTH-1:0]         rd_addr_i,

  output reg                           rd_en_o, 
  output reg                           wr_en_o, 

  output reg                           bias_mode_o,

  output wire [DATA_WIDTH-1:0]         o_accum_data_0, 
  output wire [DATA_WIDTH-1:0]         o_accum_data_1,
  output reg  [ADDR_WIDTH-1:0]         rd_addr_o, 

  input  wire                          i_execute_out_fifo_wr_en,//final data
  output reg                           o_execute_out_fifo_wr_en,
  input  wire                          i_execute_out_fifo_rd_en,

  output wire                          o_execute_out_fifo_empty,
  output wire                          o_execute_out_fifo_full,

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
wire [DATA_WIDTH-1:0] add_0_data_out, add_1_data_out;
wire [DATA_WIDTH-1:0] accum_0_data, accum_1_data;

wire [ADDR_WIDTH-1:0]         wr_addr;

reg [31:0]           fifo_data_out_0, fifo_data_out_1;

  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      wr_en_o <= 'd0;
      o_execute_out_fifo_wr_en <= 'd0;
    end
    else
    begin
      wr_en_o <= wr_en_i;
      o_execute_out_fifo_wr_en <= i_execute_out_fifo_wr_en;
    end
  end
  
  always@(posedge clk)
  begin
    bias_mode_o <= bias_mode_i;
    rd_addr_o <= rd_addr_i;
    rd_en_o <= rd_en_i;
    if(i_prepare_weight)
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
    if(i_set_bias)
    begin
      fifo_data_out_0 <= {o_load_weight_data_a_0,
                          o_load_weight_data_b_0,
                          o_load_weight_data_c_0,
                          o_load_weight_data_d_0};


      fifo_data_out_1 <= {o_load_weight_data_a_1,
                          o_load_weight_data_b_1,
                          o_load_weight_data_c_1,
                          o_load_weight_data_d_1};
    end
  end

  variable_length_shift_register
  #(
    .DATA_WIDTH(ADDR_WIDTH),
    .DELAY(7) 
  ) accum_wr_delay
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data(rd_addr_i),
    .o_data(wr_addr)
  );
  
  
  bram_accumulator
  #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) bram_accumulator_0(
    .clk(clk),
    .i_rd_en(rd_en_i), 
    .i_wr_en(wr_en_i),
  
    .i_wr_addr(wr_addr),
    .i_data(add_0_data_out),
    .i_rd_addr(rd_addr_i),
    .o_data(accum_0_data)  
  );
  
    bram_accumulator
  #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) bram_accumulator_1(
    .clk(clk),
    .i_rd_en(rd_en_i), 
    .i_wr_en(wr_en_i),
  
    .i_wr_addr(wr_addr),
    .i_data(add_1_data_out),
    .i_rd_addr(rd_addr_i),
    .o_data(accum_1_data)  
  );
 
  fp32_adder_dual 
  #(
    .EXPONENT_WIDTH(8),
    .MANTISA_WIDTH(24)
  ) fp32_adder_dual(
    //input
    //control signals
    .clk(clk),
    .bias_mode(bias_mode_i),
  
    //data in
    //exponent
    .exponent_acc_0(accum_0_data[31:24]), 
    .exponent_bias_0(fifo_data_out_0[31:24]), 
    .exponent_b_0(data_in_0[31:24]), 
    .exponent_acc_1(accum_1_data[31:24]), 
    .exponent_bias_1(fifo_data_out_1[31:24]), 
    .exponent_b_1(data_in_1[31:24]), 
    //mantissa
    .mantissa_acc_0(accum_0_data[23:0]), 
    .mantissa_bias_0(fifo_data_out_0[23:0]), 
    .mantissa_b_0(data_in_0[23:0]), 
    .mantissa_acc_1(accum_1_data[23:0]), 
    .mantissa_bias_1(fifo_data_out_1[23:0]), 
    .mantissa_b_1(data_in_1[23:0]), 
    
    //data out
    .exponent_0_out(add_0_data_out[31:24]), 
    .exponent_1_out(add_1_data_out[31:24]),
    .mantissa_0_out(add_0_data_out[23:0]), 
    .mantissa_1_out(add_1_data_out[23:0])
  );
  
  fifo_registered_output
#(
  .ADDR_WIDTH(6),
  .DATA_WIDTH(64)
) accumulator_out_fifo(
   .clk(clk), 
   .rst_n(rst_n),
   .rd_en(i_execute_out_fifo_rd_en), 
   .wr_en(i_execute_out_fifo_wr_en),
   .data_in({add_0_data_out, add_1_data_out}),
   .fifo_empty(o_execute_out_fifo_empty), 
   .fifo_full(o_execute_out_fifo_full),
   .data_out({o_accum_data_0, o_accum_data_1})
);


/*
  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(64),
    .REG_OUT("yes")
  ) bias_data_fifo(
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(i_set_bias), 
    .wr_en(i_bias_data_fifo_wr_en),
    .data_in(
       {o_load_weight_data_a_0,
        o_load_weight_data_b_0,
        o_load_weight_data_c_0,
        o_load_weight_data_d_0,

        o_load_weight_data_a_1,
        o_load_weight_data_b_1,
        o_load_weight_data_c_1,
        o_load_weight_data_d_1}
        ),
    .fifo_empty(), 
    .fifo_full(),
    .data_out({fifo_data_out_0, fifo_data_out_1})
  );
*/


endmodule