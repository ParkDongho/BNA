`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/23 00:25:33
// Design Name: 
// Module Name: Load
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


module Load
#(
  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8
  
)
(
  input  wire clk, rst_n,
  input  wire load_data_reg_wr_en,
  input  wire [2:0] sel_load_data,
  //AXI Master Read=============================================================================
  input  wire [AXI_WIDTH_DA-1:0]      m_axi_memory_bus_RDATA, //Read data.


  //Load Out==================================================================================
  output  wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
               load_mantissa_0_o,  load_mantissa_1_o,  load_mantissa_2_o,  load_mantissa_3_o,
               load_mantissa_4_o,  load_mantissa_5_o,  load_mantissa_6_o,  load_mantissa_7_o,
               load_mantissa_8_o,  load_mantissa_9_o,  load_mantissa_10_o, load_mantissa_11_o,
               load_mantissa_12_o, load_mantissa_13_o, load_mantissa_14_o, load_mantissa_15_o,
               load_mantissa_16_o, load_mantissa_17_o, load_mantissa_18_o, load_mantissa_19_o,
               load_mantissa_20_o, load_mantissa_21_o, load_mantissa_22_o, load_mantissa_23_o,
               load_mantissa_24_o, load_mantissa_25_o, load_mantissa_26_o, load_mantissa_27_o,
               load_mantissa_28_o, load_mantissa_29_o, load_mantissa_30_o, load_mantissa_31_o,
  output  wire [EXPONENT_WIDTH-1:0] load_exponent_o
);

  reg [31:0] axi_activation_brodcaster [7:0];

  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      axi_activation_brodcaster[0] <= 'd0;
      axi_activation_brodcaster[1] <= 'd0;
      axi_activation_brodcaster[2] <= 'd0;
      axi_activation_brodcaster[3] <= 'd0;
      axi_activation_brodcaster[4] <= 'd0;
      axi_activation_brodcaster[5] <= 'd0;
      axi_activation_brodcaster[6] <= 'd0;
      axi_activation_brodcaster[7] <= 'd0;
    end
    else
    begin
      if(load_data_reg_wr_en)
        case(sel_load_data)
          3'b000 : axi_activation_brodcaster[0] <= m_axi_memory_bus_RDATA;
          3'b001 : axi_activation_brodcaster[1] <= m_axi_memory_bus_RDATA;
          3'b010 : axi_activation_brodcaster[2] <= m_axi_memory_bus_RDATA;
          3'b011 : axi_activation_brodcaster[3] <= m_axi_memory_bus_RDATA;
          3'b100 : axi_activation_brodcaster[4] <= m_axi_memory_bus_RDATA;
          3'b101 : axi_activation_brodcaster[5] <= m_axi_memory_bus_RDATA;
          3'b110 : axi_activation_brodcaster[6] <= m_axi_memory_bus_RDATA;
          3'b111 : axi_activation_brodcaster[7] <= m_axi_memory_bus_RDATA;
        endcase
    end
  end


  assign{load_mantissa_31_o, load_mantissa_30_o, load_mantissa_29_o, load_mantissa_28_o,
        load_mantissa_27_o, load_mantissa_26_o, load_mantissa_25_o, load_mantissa_24_o,
        load_mantissa_23_o, load_mantissa_22_o, load_mantissa_21_o, load_mantissa_20_o,
        load_mantissa_19_o, load_mantissa_18_o, load_mantissa_17_o, load_mantissa_16_o,
        load_mantissa_15_o, load_mantissa_14_o, load_mantissa_13_o, load_mantissa_12_o,
        load_mantissa_11_o, load_mantissa_10_o, load_mantissa_9_o,  load_mantissa_8_o,
        load_mantissa_7_o,  load_mantissa_6_o,  load_mantissa_5_o,  load_mantissa_4_o,
        load_mantissa_3_o,  load_mantissa_2_o,  load_mantissa_1_o,  load_mantissa_0_o}
        = {axi_activation_brodcaster[6], axi_activation_brodcaster[5], axi_activation_brodcaster[4], axi_activation_brodcaster[3], 
          axi_activation_brodcaster[2], axi_activation_brodcaster[1], axi_activation_brodcaster[0]};

  assign load_exponent_o = axi_activation_brodcaster[7];

endmodule
