`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:08:42
// Design Name: 
// Module Name: programable_vector_unit_dual
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


module programable_vector_unit_dual
#(
  parameter EXPONENT_WIDTH = 8,
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter PARAM_ROM_ADDR_WIDTH = 8,
  parameter ACCUM_DATA_WIDTH = 32
) 
(
  input  wire clk, rst_n,
  input  wire i_prepare_weight, i_set_param,
  input  wire i_param_data_fifo_wr_en,
  input  wire rd_en_i, wr_en_i,
  input  wire i_activation_out_fifo_rd_en, i_activation_out_fifo_wr_en,
  input  wire [3:0] vetor_unit_op,
  input  wire [ACCUM_DATA_WIDTH-1:0] data_in_0, data_in_1,
  output wire fifo_empty, fifo_full,
  output wire o_activation_out_fifo_empty, o_activation_out_fifo_full,

  output wire [ACCUM_DATA_WIDTH-1:0] data_out_0, data_out_1,

  //Load Weight In/////////////////////////////////////////////////////////////////
  input   wire [7:0]                 i_load_weight_data_a_0,
  input   wire [7:0]                 i_load_weight_data_b_0,
  input   wire [7:0]                 i_load_weight_data_c_0,
  input   wire [7:0]                 i_load_weight_data_d_0,

  input   wire [7:0]                 i_load_weight_data_a_1,
  input   wire [7:0]                 i_load_weight_data_b_1,
  input   wire [7:0]                 i_load_weight_data_c_1,
  input   wire [7:0]                 i_load_weight_data_d_1
);
  wire [ACCUM_DATA_WIDTH-1:0] mul_data_0_o, mul_data_1_o; //mul out -> alu a in 
  
  wire [ACCUM_DATA_WIDTH-1:0] alu_data_b_0_i, alu_data_b_1_i; //fifo out -> alu b in
  
  wire [ACCUM_DATA_WIDTH-1:0] alu_data_0_o, alu_data_1_o; //alu out -> fifo in
  
  wire [2*ACCUM_DATA_WIDTH-1:0] fifo_data_i, fifo_data_o;
  
  reg [ACCUM_DATA_WIDTH-1:0] data_in_0_tmp, data_in_1_tmp;
  reg [25:0] weight_fifo_data_0_tmp, weight_fifo_data_1_tmp;
  
  reg [7:0]                            load_weight_data_a_p_0; //positive
  reg [7:0]                            load_weight_data_b_p_0;
  reg [7:0]                            load_weight_data_c_p_0;
  reg [7:0]                            load_weight_data_d_p_0;
  
  reg [7:0]                            load_weight_data_a_n_0; //negative
  reg [7:0]                            load_weight_data_b_n_0;
  reg [7:0]                            load_weight_data_c_n_0;
  reg [7:0]                            load_weight_data_d_n_0;
  
  reg [7:0]                            load_weight_data_a_p_1;
  reg [7:0]                            load_weight_data_b_p_1;
  reg [7:0]                            load_weight_data_c_p_1;
  reg [7:0]                            load_weight_data_d_p_1;
  
  reg [7:0]                            load_weight_data_a_n_1;
  reg [7:0]                            load_weight_data_b_n_1;
  reg [7:0]                            load_weight_data_c_n_1;
  reg [7:0]                            load_weight_data_d_n_1;
  
  wire [25:0]                          fifo_data_out_p_0;
  wire [25:0]                          fifo_data_out_p_1;
  
  wire [25:0]                          fifo_data_out_n_0;
  wire [25:0]                          fifo_data_out_n_1;
  
  always @(posedge clk)
  begin
    data_in_0_tmp <= data_in_0;
    data_in_1_tmp <= data_in_1;
    weight_fifo_data_0_tmp <= data_in_0[23] ? fifo_data_out_n_0 : fifo_data_out_p_0;
    weight_fifo_data_1_tmp <= data_in_1[23] ? fifo_data_out_n_1 : fifo_data_out_p_1;
  
    if(i_prepare_weight)
    begin
      load_weight_data_a_p_0 <= i_load_weight_data_a_0;
      load_weight_data_b_p_0 <= i_load_weight_data_b_0;
      load_weight_data_c_p_0 <= i_load_weight_data_c_0;
      load_weight_data_d_p_0 <= i_load_weight_data_d_0;
  
      load_weight_data_a_p_1 <= i_load_weight_data_a_1;
      load_weight_data_b_p_1 <= i_load_weight_data_b_1;
      load_weight_data_c_p_1 <= i_load_weight_data_c_1;
      load_weight_data_d_p_1 <= i_load_weight_data_d_1;
  
      load_weight_data_a_n_0 <= load_weight_data_a_p_0;
      load_weight_data_b_n_0 <= load_weight_data_b_p_0;
      load_weight_data_c_n_0 <= load_weight_data_c_p_0;
      load_weight_data_d_n_0 <= load_weight_data_d_p_0;
  
      load_weight_data_a_n_1 <= load_weight_data_a_p_1;
      load_weight_data_b_n_1 <= load_weight_data_b_p_1;
      load_weight_data_c_n_1 <= load_weight_data_c_p_1;
      load_weight_data_d_n_1 <= load_weight_data_d_p_1;
    end
  end



  // Instantiate the fp32 multipliers
  //multiplier 0
  fp32_multiplier
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_A_WIDTH(24),
    .MANTISSA_B_WIDTH(18),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH)
  ) fp32_multiplier_0(
    //control signal in
    .clk(clk), 
    .mul_op(vetor_unit_op[0]),
    //data in
    .mul_data_a_i(data_in_0_tmp),
    .mul_data_b_i(weight_fifo_data_0_tmp),
    //data out
    .mul_data_o(mul_data_0_o)
  );

  //multiplier 1
  fp32_multiplier
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_A_WIDTH(24),
    .MANTISSA_B_WIDTH(18),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH)
  ) fp32_multiplier_1(
    //control signal in
    .clk(clk), 
    .mul_op(vetor_unit_op[0]),
    //data in
    .mul_data_a_i(data_in_1_tmp),
    .mul_data_b_i(weight_fifo_data_1_tmp),
    //data out
    .mul_data_o(mul_data_1_o)
  );

  // Instantiate the fp7 alu
  //alu0
  fp7_alu
  #(
    .EXPONENT_WIDTH(8),
    .MANTISSA_WIDTH(7),
    .ACCUM_DATA_WIDTH(32)
  ) fp7_alu_0(
    //control signal in
    .clk(clk),
    .alu_op(vetor_unit_op[1]),
    //data in
    .alu_data_a_i(mul_data_0_o),
    .alu_data_b_i(alu_data_b_0_i),
    //data out
    .alu_data_o(alu_data_0_o)
  );

  //alu1
  fp7_alu
  #(
    .EXPONENT_WIDTH(8),
    .MANTISSA_WIDTH(7),
    .ACCUM_DATA_WIDTH(32)
  ) fp7_alu_1(
    //control signal in
    .clk(clk),
    .alu_op(vetor_unit_op[1]),
    //data in
    .alu_data_a_i(mul_data_1_o),
    .alu_data_b_i(alu_data_b_1_i),
    //data out
    .alu_data_o(alu_data_1_o)
  );

  //Instantiate the 28bit bram fifo
  fifo_registered_output #(
    .ADDR_WIDTH(6),
    .DATA_WIDTH((2*ACCUM_DATA_WIDTH))
  ) activation_accum_fifo(
     .clk(clk), 
     .rst_n(rst_n),
     .rd_en(rd_en_i),
     .wr_en(wr_en_i),
     .data_in(fifo_data_i),
   
     .fifo_empty(fifo_empty), 
     .fifo_full(fifo_full),
     .data_out(fifo_data_o)
  );

  //Instantiate the 28bit bram fifo
  fifo_registered_output #(
    .ADDR_WIDTH(6),
    .DATA_WIDTH((2*ACCUM_DATA_WIDTH))
  ) activation_out_fifo(
     .clk(clk), 
     .rst_n(rst_n),
     .rd_en(i_activation_out_fifo_rd_en),
     .wr_en(i_activation_out_fifo_wr_en),
     .data_in(fifo_data_i),
   
     .fifo_empty(o_activation_out_fifo_empty), 
     .fifo_full(o_activation_out_fifo_full),
     .data_out({data_out_0, data_out_1})
  );

  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(26*4)
  ) param_data_fifo(
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(i_set_param), 
    .wr_en(i_param_data_fifo_wr_en),
    .data_in(
     {load_weight_data_a_p_0[1:0],
      load_weight_data_b_p_0,
      load_weight_data_c_p_0,
      load_weight_data_d_p_0,

      load_weight_data_a_p_1[1:0],
      load_weight_data_b_p_1,
      load_weight_data_c_p_1,
      load_weight_data_d_p_1,

      load_weight_data_a_n_0[1:0],
      load_weight_data_b_n_0,
      load_weight_data_c_n_0,
      load_weight_data_d_n_0,

      load_weight_data_a_n_1[1:0],
      load_weight_data_b_n_1,
      load_weight_data_c_n_1,
      load_weight_data_d_n_1}
      ),
    .fifo_empty(), 
    .fifo_full(),
    .data_out({
      fifo_data_out_p_0,
      fifo_data_out_p_1,

      fifo_data_out_n_0,
      fifo_data_out_n_1
    })
  );

  assign fifo_data_i = {alu_data_0_o, alu_data_1_o};
  assign {alu_data_b_0_i, alu_data_b_1_i} = fifo_data_o;
  
endmodule
