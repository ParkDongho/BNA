`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:11:37
// Design Name: 
// Module Name: bram_fifo
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


module bram_fifo
#(
  parameter ADDR_WIDTH = 8,
  parameter DATA_WIDTH = 64
) (
   input wire clk, rst_n,
   input wire rd_en, wr_en_in,
   input  wire [DATA_WIDTH-1:0] data_in,
   output wire fifo_empty, fifo_full,
   output wire [DATA_WIDTH-1:0] data_out
);
  
  reg fifo_empty_reg, fifo_empty_nxt;
  reg fifo_full_reg, fifo_full_nxt;
  reg [ADDR_WIDTH-1:0] rd_ptr_reg, rd_ptr_nxt, rd_ptr_succ; //read pointer
  reg [ADDR_WIDTH-1:0] wr_ptr_reg, wr_ptr_nxt, wr_ptr_succ; //write pointer
  
  
  simple_dual_port_no_rden #(
  .ADDR_WIDTH(ADDR_WIDTH),
  .DATA_WIDTH(DATA_WIDTH)
) simple_dual_port_ram(
  .clk(clk),
  .wr_en(wr_en_in),
  .wr_addr(wr_ptr_reg),
  .data_i(data_in),
  .rd_addr(rd_ptr_reg),
  .data_o_r(data_out)
);
  
  // fifo controll logic
  always @(posedge clk)
  begin
    if (rst_n==1'b0) 
    begin
      rd_ptr_reg <= 'd0;
      wr_ptr_reg <= 'd0;
      fifo_full_reg <= 1'b0;
      fifo_empty_reg <= 1'b1;
    end
    else 
    begin;
      rd_ptr_reg <= rd_ptr_nxt;
      wr_ptr_reg <= wr_ptr_nxt;
      fifo_full_reg <= fifo_full_nxt;
      fifo_empty_reg <= fifo_empty_nxt;
    end
  end
  
  always @(*) //next state logic
  begin
    rd_ptr_succ = rd_ptr_reg + 1'b1;
    wr_ptr_succ = wr_ptr_reg + 1'b1;
    rd_ptr_nxt = rd_ptr_reg;
    wr_ptr_nxt = wr_ptr_reg;
    fifo_full_nxt = fifo_full_reg;
    fifo_empty_nxt = fifo_empty_reg;
    casex({wr_en_in, rd_en, fifo_empty_reg, fifo_full_reg})
      4'b010x: //read only & not empty : successful read
      begin
        rd_ptr_nxt = rd_ptr_succ;
        fifo_full_nxt = 1'b0;
        if (rd_ptr_succ == wr_ptr_reg)
        begin
          fifo_empty_nxt = 1'b1;
        end
      end
      4'b10x0: //write only & not full : successful write
      begin
        wr_ptr_nxt = wr_ptr_succ;
        fifo_empty_nxt = 1'b0;
        if (wr_ptr_succ==rd_ptr_reg) 
        begin
          fifo_full_nxt = 1'b1;
        end
      end
      4'b110x: //read & write & not empty : successful read and write 
      begin
        wr_ptr_nxt = wr_ptr_succ;
        rd_ptr_nxt = rd_ptr_succ;
      end
      4'b111x: //read & write & empty : successful read with failed write 
      begin
        wr_ptr_nxt = wr_ptr_succ;
        fifo_empty_nxt = 1'b0;
      end
    endcase
  end
  assign fifo_full = fifo_full_reg;
  assign fifo_empty = fifo_empty_reg;
endmodule
