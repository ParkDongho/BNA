`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/25 17:38:08
// Design Name: 
// Module Name: fp7_alu_select_stage
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


module fp7_alu_select_stage
#(
  parameter ACCUM_DATA_WIDTH =32
)
(
  input wire clk, select_data,
  input wire i_exponent_big_a,
  input wire alu_op,
  input wire signed [ACCUM_DATA_WIDTH-1:0] alu_data_a_i, alu_data_b_i,
  output reg signed [ACCUM_DATA_WIDTH-1:0] alu_data_o
);
  reg signed [ACCUM_DATA_WIDTH-1:0] pipeline_reg_alu_data_a [3:0];
  reg signed [ACCUM_DATA_WIDTH-1:0] pipeline_reg_alu_data_b [3:0];
  always @(posedge clk)
  begin
    pipeline_reg_alu_data_a[3] <= pipeline_reg_alu_data_a[2];
    pipeline_reg_alu_data_a[2] <= pipeline_reg_alu_data_a[1];
    pipeline_reg_alu_data_a[1] <= pipeline_reg_alu_data_a[0];
    pipeline_reg_alu_data_a[0] <= alu_data_a_i;
    
    pipeline_reg_alu_data_b[3] <= pipeline_reg_alu_data_b[2];    
    pipeline_reg_alu_data_b[2] <= pipeline_reg_alu_data_b[1];
    pipeline_reg_alu_data_b[1] <= pipeline_reg_alu_data_b[0];
    pipeline_reg_alu_data_b[0] <= alu_data_b_i;
    
    casex({alu_op, select_data, i_exponent_big_a})
      3'b0xx : alu_data_o <= pipeline_reg_alu_data_a[3];
      
      3'b100 : alu_data_o <= pipeline_reg_alu_data_b[3];
      3'b101 : alu_data_o <= pipeline_reg_alu_data_a[3];
      3'b110 : alu_data_o <= pipeline_reg_alu_data_a[3];
      3'b111 : alu_data_o <= pipeline_reg_alu_data_b[3];
      default : alu_data_o <= 'd0;     
    endcase
  end
  endmodule
