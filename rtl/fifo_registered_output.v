`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/20 23:15:31
// Design Name: 
// Module Name: fifo_registered_output
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


module fifo_registered_output
#(
  parameter ADDR_WIDTH = 5,
  parameter DATA_WIDTH = 64,
  parameter REG_OUT = "yes"
) (
   input wire clk, rst_n,
   input wire rd_en, wr_en,
   input  wire [DATA_WIDTH-1:0] data_in,
   output wire fifo_empty, fifo_full,
   output wire [DATA_WIDTH-1:0] data_out
);
  wire [DATA_WIDTH-1:0] data_out_wire;
  generate///////////////////////////////////////////////////////////////////////
    if(ADDR_WIDTH > 6)//BRAM FIFO////////////////////////////////////////////////
    begin////////////////////////////////////////////////////////////////////////
      reg fifo_empty_reg, fifo_empty_nxt;
      reg fifo_full_reg, fifo_full_nxt;
      reg [ADDR_WIDTH-1:0] rd_ptr_reg, rd_ptr_nxt, rd_ptr_succ; //read pointer
      reg [ADDR_WIDTH-1:0] wr_ptr_reg, wr_ptr_nxt, wr_ptr_succ; //write pointer
      
      
      
      simple_dual_port_no_rden #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
      ) simple_dual_port_ram(
        .clk(clk),
        .wr_en(wr_en),
        .wr_addr(wr_ptr_reg),
        .data_i(data_in),
        .rd_addr(rd_ptr_reg),
        .data_o_r(data_out_wire)
      );
      
      // fifo controll logic
      always @(posedge clk, negedge rst_n)
      begin
        if (!rst_n) 
        begin
          rd_ptr_reg <= 'd0;
          wr_ptr_reg <= 'd0;
          fifo_full_reg <= 1'b0;
          fifo_empty_reg <= 1'b1;
        end
        else 
        begin
          rd_ptr_reg <= rd_ptr_nxt;
          wr_ptr_reg <= wr_ptr_nxt;
          fifo_full_reg <= fifo_full_nxt;
          fifo_empty_reg <= fifo_empty_nxt;
        end
      end
      
      if(REG_OUT == "yes")
      begin
        reg  [DATA_WIDTH-1:0] data_out_reg;
        always @(posedge clk)
        begin
          if(rd_en)
            data_out_reg <= data_out_wire;
        end
        assign data_out = data_out_reg;
      end
      else if(REG_OUT == "no")
      begin
        assign data_out = data_out_wire;
      end
      
      always @(*) //next state logic
      begin
        rd_ptr_succ = rd_ptr_reg + 1'b1;
        wr_ptr_succ = wr_ptr_reg + 1'b1;
        rd_ptr_nxt = rd_ptr_reg;
        wr_ptr_nxt = wr_ptr_reg;
        fifo_full_nxt = fifo_full_reg;
        fifo_empty_nxt = fifo_empty_reg;
        casex({wr_en, rd_en, fifo_empty_reg, fifo_full_reg})
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
    end////////////////////////////////////////////////////////////////////////////////////////
    else//SRLC FIFO////////////////////////////////////////////////////////////////////////////
    begin//////////////////////////////////////////////////////////////////////////////////////
      // signal declaration

      reg fifo_full_reg, fifo_full_nxt; //fifo full flag
      reg fifo_empty_reg, fifo_empty_nxt;
      reg [ADDR_WIDTH:0] rd_ptr_reg, rd_ptr_nxt; //read pointer //write pointer is always 0

      
      // fifo controll logic
      always @(posedge clk)
      begin
        if (rst_n==1'b0) begin
          rd_ptr_reg <= {(ADDR_WIDTH+1){1'b1}};
          fifo_empty_reg <= 1'b1;
          fifo_full_reg <= 1'b0;
        end
        else 
        begin
          rd_ptr_reg <= rd_ptr_nxt; //update read pointer
          fifo_full_reg  <= fifo_full_nxt; //update full flag
          fifo_empty_reg <= fifo_empty_nxt;
        end
      end
      
      if(REG_OUT == "yes")
      begin
        reg  [DATA_WIDTH-1:0] data_out_reg;
        always @(posedge clk)
        begin
          if(rd_en)
            data_out_reg <= data_out_wire;
        end
        assign data_out = data_out_reg;
      end
      else if(REG_OUT == "no")
      begin
        assign data_out = data_out_wire;
      end
      
      // next state logic
      always @(*)
      begin
        rd_ptr_nxt = rd_ptr_reg;
        fifo_empty_nxt = fifo_empty_reg;
        fifo_full_nxt = fifo_full_reg;
        casex({wr_en, rd_en, fifo_empty_reg, fifo_full_reg})
          4'b010x: //read only
          begin
            rd_ptr_nxt = rd_ptr_reg - 1'b1;          
            fifo_full_nxt = 1'b0; 
            if(rd_ptr_reg == 'b0)
            begin
              fifo_empty_nxt = 1'b1;
            end
          end
          4'b10x0: //write only
          begin
            rd_ptr_nxt = rd_ptr_reg + 1'b1;
            fifo_empty_nxt = 1'b0; 
            if(rd_ptr_reg == {1'b0,{(ADDR_WIDTH-1){1'b1}}, 1'b0})
            begin
              fifo_full_nxt = 1'b1;
            end
          end
        endcase
      end
      
      assign fifo_empty = fifo_empty_reg;
      assign fifo_full = fifo_full_reg;
      
      // SRLC32E primitive instantiation
      genvar index;
      for(index=0; index<DATA_WIDTH; index=index+1) 
      begin
        SRLC_RTL
        #( 
          .ADDR_WIDTH(ADDR_WIDTH)
        )SRLC_RTL(
          .clk(clk),
          .wr_en(wr_en&((!fifo_full_reg)|(fifo_full_reg&rd_en))),
          .i_data(data_in[index]),
          .addr(rd_ptr_reg[ADDR_WIDTH-1:0]),
          .o_data(data_out_wire[index])
        );
      end
    end
  endgenerate

endmodule
