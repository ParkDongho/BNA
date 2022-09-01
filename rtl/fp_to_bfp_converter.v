`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/25 02:19:56
// Design Name: 
// Module Name: fp_to_bfp_converter
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


module fp_to_bfp_converter
#(
  parameter SYST_ARRAY_WIDTH = 32,
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8
)
(
  input  wire clk,
  input  wire [QUNATIZED_MANTISSA_WIDTH+EXPONENT_WIDTH-1:0] 
    bfp_converter_data_0_i,  bfp_converter_data_1_i,  bfp_converter_data_2_i,  bfp_converter_data_3_i,
    bfp_converter_data_4_i,  bfp_converter_data_5_i,  bfp_converter_data_6_i,  bfp_converter_data_7_i,
    bfp_converter_data_8_i,  bfp_converter_data_9_i,  bfp_converter_data_10_i, bfp_converter_data_11_i,
    bfp_converter_data_12_i, bfp_converter_data_13_i, bfp_converter_data_14_i, bfp_converter_data_15_i,
    bfp_converter_data_16_i, bfp_converter_data_17_i, bfp_converter_data_18_i, bfp_converter_data_19_i,
    bfp_converter_data_20_i, bfp_converter_data_21_i, bfp_converter_data_22_i, bfp_converter_data_23_i,
    bfp_converter_data_24_i, bfp_converter_data_25_i, bfp_converter_data_26_i, bfp_converter_data_27_i,
    bfp_converter_data_28_i, bfp_converter_data_29_i, bfp_converter_data_30_i, bfp_converter_data_31_i,
    
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
    bfp_converter_data_0_o,  bfp_converter_data_1_o,  bfp_converter_data_2_o,  bfp_converter_data_3_o,
    bfp_converter_data_4_o,  bfp_converter_data_5_o,  bfp_converter_data_6_o,  bfp_converter_data_7_o,
    bfp_converter_data_8_o,  bfp_converter_data_9_o,  bfp_converter_data_10_o, bfp_converter_data_11_o,
    bfp_converter_data_12_o, bfp_converter_data_13_o, bfp_converter_data_14_o, bfp_converter_data_15_o,
    bfp_converter_data_16_o, bfp_converter_data_17_o, bfp_converter_data_18_o, bfp_converter_data_19_o,
    bfp_converter_data_20_o, bfp_converter_data_21_o, bfp_converter_data_22_o, bfp_converter_data_23_o,
    bfp_converter_data_24_o, bfp_converter_data_25_o, bfp_converter_data_26_o, bfp_converter_data_27_o,
    bfp_converter_data_28_o, bfp_converter_data_29_o, bfp_converter_data_30_o, bfp_converter_data_31_o,
  output wire [EXPONENT_WIDTH-1:0] bfp_converter_data_expoent_o
);
  wire [(EXPONENT_WIDTH+QUNATIZED_MANTISSA_WIDTH)*SYST_ARRAY_WIDTH-1:0] fp_data_in;
  wire [QUNATIZED_MANTISSA_WIDTH*SYST_ARRAY_WIDTH+EXPONENT_WIDTH-1:0] bfp_data_out;
  
  reg [QUNATIZED_MANTISSA_WIDTH+EXPONENT_WIDTH-1:0] 
    bfp_converter_data_0,  bfp_converter_data_1,  bfp_converter_data_2,  bfp_converter_data_3,
    bfp_converter_data_4,  bfp_converter_data_5,  bfp_converter_data_6,  bfp_converter_data_7,
    bfp_converter_data_8,  bfp_converter_data_9,  bfp_converter_data_10, bfp_converter_data_11,
    bfp_converter_data_12, bfp_converter_data_13, bfp_converter_data_14, bfp_converter_data_15,
    bfp_converter_data_16, bfp_converter_data_17, bfp_converter_data_18, bfp_converter_data_19,
    bfp_converter_data_20, bfp_converter_data_21, bfp_converter_data_22, bfp_converter_data_23,
    bfp_converter_data_24, bfp_converter_data_25, bfp_converter_data_26, bfp_converter_data_27,
    bfp_converter_data_28, bfp_converter_data_29, bfp_converter_data_30, bfp_converter_data_31;
  
  always@(posedge clk)
  begin
    bfp_converter_data_0 <= bfp_converter_data_0_i;
    bfp_converter_data_1 <= bfp_converter_data_1_i;
    bfp_converter_data_2 <= bfp_converter_data_2_i;
    bfp_converter_data_3 <= bfp_converter_data_3_i;
    bfp_converter_data_4 <= bfp_converter_data_4_i;
    bfp_converter_data_5 <= bfp_converter_data_5_i;
    bfp_converter_data_6 <= bfp_converter_data_6_i;
    bfp_converter_data_7 <= bfp_converter_data_7_i;
    bfp_converter_data_8 <= bfp_converter_data_8_i;
    bfp_converter_data_9 <= bfp_converter_data_9_i;
    bfp_converter_data_10 <= bfp_converter_data_10_i;
    bfp_converter_data_11 <= bfp_converter_data_11_i;
    bfp_converter_data_12 <= bfp_converter_data_12_i;
    bfp_converter_data_13 <= bfp_converter_data_13_i;
    bfp_converter_data_14 <= bfp_converter_data_14_i;
    bfp_converter_data_15 <= bfp_converter_data_15_i;
    bfp_converter_data_16 <= bfp_converter_data_16_i;
    bfp_converter_data_17 <= bfp_converter_data_17_i;
    bfp_converter_data_18 <= bfp_converter_data_18_i;
    bfp_converter_data_19 <= bfp_converter_data_19_i;
    bfp_converter_data_20 <= bfp_converter_data_20_i;
    bfp_converter_data_21 <= bfp_converter_data_21_i;
    bfp_converter_data_22 <= bfp_converter_data_22_i;
    bfp_converter_data_23 <= bfp_converter_data_23_i;
    bfp_converter_data_24 <= bfp_converter_data_24_i;
    bfp_converter_data_25 <= bfp_converter_data_25_i;
    bfp_converter_data_26 <= bfp_converter_data_26_i;
    bfp_converter_data_27 <= bfp_converter_data_27_i;
    bfp_converter_data_28 <= bfp_converter_data_28_i;
    bfp_converter_data_29 <= bfp_converter_data_29_i;
    bfp_converter_data_30 <= bfp_converter_data_30_i;
    bfp_converter_data_31 <= bfp_converter_data_31_i;
  end
  
  assign fp_data_in = 
   {bfp_converter_data_0,  bfp_converter_data_1,  bfp_converter_data_2,  bfp_converter_data_3,
    bfp_converter_data_4,  bfp_converter_data_5,  bfp_converter_data_6,  bfp_converter_data_7,
    bfp_converter_data_8,  bfp_converter_data_9,  bfp_converter_data_10, bfp_converter_data_11,
    bfp_converter_data_12, bfp_converter_data_13, bfp_converter_data_14, bfp_converter_data_15,
    bfp_converter_data_16, bfp_converter_data_17, bfp_converter_data_18, bfp_converter_data_19,
    bfp_converter_data_20, bfp_converter_data_21, bfp_converter_data_22, bfp_converter_data_23,
    bfp_converter_data_24, bfp_converter_data_25, bfp_converter_data_26, bfp_converter_data_27,
    bfp_converter_data_28, bfp_converter_data_29, bfp_converter_data_30, bfp_converter_data_31};

  assign
   {bfp_converter_data_expoent_o,
    bfp_converter_data_0_o,  bfp_converter_data_1_o,  bfp_converter_data_2_o,  bfp_converter_data_3_o,
    bfp_converter_data_4_o,  bfp_converter_data_5_o,  bfp_converter_data_6_o,  bfp_converter_data_7_o,
    bfp_converter_data_8_o,  bfp_converter_data_9_o,  bfp_converter_data_10_o, bfp_converter_data_11_o,
    bfp_converter_data_12_o, bfp_converter_data_13_o, bfp_converter_data_14_o, bfp_converter_data_15_o,
    bfp_converter_data_16_o, bfp_converter_data_17_o, bfp_converter_data_18_o, bfp_converter_data_19_o,
    bfp_converter_data_20_o, bfp_converter_data_21_o, bfp_converter_data_22_o, bfp_converter_data_23_o,
    bfp_converter_data_24_o, bfp_converter_data_25_o, bfp_converter_data_26_o, bfp_converter_data_27_o,
    bfp_converter_data_28_o, bfp_converter_data_29_o, bfp_converter_data_30_o, bfp_converter_data_31_o} = bfp_data_out;
   
  //stage 1
  wire [EXPONENT_WIDTH-1:0] stage_1_exponent_ [SYST_ARRAY_WIDTH-1:0];
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_1_mantissa_ [SYST_ARRAY_WIDTH-1:0];
  reg  [QUNATIZED_MANTISSA_WIDTH-1:0] stage_1_mantissa_reg_ [SYST_ARRAY_WIDTH-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_1_exponent_diff_ [SYST_ARRAY_WIDTH/1-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_1_exponent_big_ [SYST_ARRAY_WIDTH/2-1:0];

  //stage 2
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_2_mantissa_ [SYST_ARRAY_WIDTH-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_2_exponent_diff_ [SYST_ARRAY_WIDTH/2-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_2_exponent_big_ [SYST_ARRAY_WIDTH/4-1:0]; 
  
  //stage 3
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_3_mantissa_ [SYST_ARRAY_WIDTH-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_3_exponent_diff_ [SYST_ARRAY_WIDTH/4-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_3_exponent_big_ [SYST_ARRAY_WIDTH/8-1:0];   
  
  //stage 4
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_4_mantissa_ [SYST_ARRAY_WIDTH-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_4_exponent_diff_ [SYST_ARRAY_WIDTH/8-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_4_exponent_big_ [SYST_ARRAY_WIDTH/16-1:0];     
  
  //stage 5
  wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_5_mantissa_ [SYST_ARRAY_WIDTH-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_5_exponent_diff_ [SYST_ARRAY_WIDTH/16-1:0];
  wire [EXPONENT_WIDTH-1:0] stage_5_exponent_big_ [SYST_ARRAY_WIDTH/32-1:0];   
  
  //stage 6
 wire [QUNATIZED_MANTISSA_WIDTH-1:0] stage_6_mantissa_ [SYST_ARRAY_WIDTH-1:0];
 reg  [EXPONENT_WIDTH-1:0] stage_6_exponent_reg;
  
  //stage 1
  genvar x;
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      assign {stage_1_exponent_[x], stage_1_mantissa_[x]} 
             = fp_data_in[((x+1)*(EXPONENT_WIDTH+QUNATIZED_MANTISSA_WIDTH))-1
             :x*(EXPONENT_WIDTH+QUNATIZED_MANTISSA_WIDTH)];
      
      always @(posedge clk)
      begin
        stage_1_mantissa_reg_[x] <= stage_1_mantissa_[x];
      end
    end
  endgenerate
  
   generate
     for (x=0; x<SYST_ARRAY_WIDTH/2; x = x + 1)
     begin
        bfp_converter_compare_exponent #(
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_1_Compare_Exponent(
      //input
      .clk(clk), 
      .exponent_a(stage_1_exponent_[2*x]), 
      .exponent_b(stage_1_exponent_[2*x+1]),
      //output
      .exponent_diff_a(stage_1_exponent_diff_[2*x]), 
      .exponent_diff_b(stage_1_exponent_diff_[2*x+1]), 
      .exponent_big(stage_1_exponent_big_[x])
      );
    end
  endgenerate

  //stage 2
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      bfp_converter_align_mantissa
      #(
        .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_2_Align_Mantissa(
        .clk(clk), 
        .exponent_diff(stage_1_exponent_diff_[x]),
        .mantissa_data_in(stage_1_mantissa_reg_[x]),
        .mantissa_alligned(stage_2_mantissa_[x])
     );
     end
  endgenerate
  
   generate
     for (x=0; x<SYST_ARRAY_WIDTH/4; x = x + 1)
     begin
        bfp_converter_compare_exponent #(
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_2_Compare_Exponent(
      //input
      .clk(clk), 
      .exponent_a(stage_1_exponent_big_[2*x]), 
      .exponent_b(stage_1_exponent_big_[2*x+1]),
      //output
      .exponent_diff_a(stage_2_exponent_diff_[2*x]), 
      .exponent_diff_b(stage_2_exponent_diff_[2*x+1]), 
      .exponent_big(stage_2_exponent_big_[x])
      );
    end
  endgenerate
  
//stage 3
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      bfp_converter_align_mantissa
      #(
        .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_3_Align_Mantissa(
        .clk(clk), 
        .exponent_diff(stage_2_exponent_diff_[x/2]),
        .mantissa_data_in(stage_2_mantissa_[x]),
        .mantissa_alligned(stage_3_mantissa_[x])
     );
     end
  endgenerate
  
   generate
    for (x=0; x<SYST_ARRAY_WIDTH/8; x = x + 1)
    begin
      bfp_converter_compare_exponent 
      #(
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_3_Compare_Exponent
      (
        //input
        .clk(clk), 
        .exponent_a(stage_2_exponent_big_[2*x]), 
        .exponent_b(stage_2_exponent_big_[2*x+1]),
        //output
        .exponent_diff_a(stage_3_exponent_diff_[2*x]), 
        .exponent_diff_b(stage_3_exponent_diff_[2*x+1]), 
        .exponent_big(stage_3_exponent_big_[x])
      );
    end
  endgenerate
  
//stage 4
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      bfp_converter_align_mantissa
      #(
        .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_4_Align_Mantissa
      (
        .clk(clk), 
        .exponent_diff(stage_3_exponent_diff_[x/4]),
        .mantissa_data_in(stage_3_mantissa_[x]),
        .mantissa_alligned(stage_4_mantissa_[x])
     );
     end
  endgenerate
  
  generate
    for (x=0; x<SYST_ARRAY_WIDTH/16; x = x + 1)
    begin
        bfp_converter_compare_exponent 
        #(
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
        ) BFP_Converter_Stage_4_Compare_Exponent
        (
          //input
          .clk(clk), 
          .exponent_a(stage_3_exponent_big_[2*x]), 
          .exponent_b(stage_3_exponent_big_[2*x+1]),
          //output
          .exponent_diff_a(stage_4_exponent_diff_[2*x]), 
          .exponent_diff_b(stage_4_exponent_diff_[2*x+1]), 
          .exponent_big(stage_4_exponent_big_[x])
        );
    end
  endgenerate
  
//stage 5
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      bfp_converter_align_mantissa 
      #(
        .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_5_Align_Mantissa(
        .clk(clk), 
        .exponent_diff(stage_4_exponent_diff_[x/8]),
        .mantissa_data_in(stage_4_mantissa_[x]),
        .mantissa_alligned(stage_5_mantissa_[x])
     );
     end
  endgenerate
  
   generate
     for (x=0; x<SYST_ARRAY_WIDTH/32; x = x + 1)
     begin
        bfp_converter_compare_exponent #(
          .EXPONENT_WIDTH(EXPONENT_WIDTH)
        ) BFP_Converter_Stage_5_Compare_Exponent(
      //input
      .clk(clk), 
      .exponent_a(stage_4_exponent_big_[2*x]), 
      .exponent_b(stage_4_exponent_big_[2*x+1]),
      //output
      .exponent_diff_a(stage_5_exponent_diff_[2*x]), 
      .exponent_diff_b(stage_5_exponent_diff_[2*x+1]), 
      .exponent_big(stage_5_exponent_big_[x])
      );
    end
  endgenerate

//stage 6
  generate
    for (x=0; x<SYST_ARRAY_WIDTH; x = x + 1)
    begin
      bfp_converter_align_mantissa
      #(
        .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
        .EXPONENT_WIDTH(EXPONENT_WIDTH)
      ) BFP_Converter_Stage_6_Align_Mantissa(
        .clk(clk), 
        .exponent_diff(stage_5_exponent_diff_[x/16]),
        .mantissa_data_in(stage_5_mantissa_[x]),
        .mantissa_alligned(stage_6_mantissa_[x])
     );
     end
  endgenerate
  
  always @(posedge clk)
  begin
    stage_6_exponent_reg <= stage_5_exponent_big_[0];
  end
  
//Instantiate output
  generate
    for (x=0; x<SYST_ARRAY_WIDTH+1; x = x + 1)
    begin
    if(x!=SYST_ARRAY_WIDTH)
      assign bfp_data_out[(x+1)*QUNATIZED_MANTISSA_WIDTH-1:x*QUNATIZED_MANTISSA_WIDTH] 
      = stage_6_mantissa_[x];
    else
      assign bfp_data_out[x*QUNATIZED_MANTISSA_WIDTH+EXPONENT_WIDTH-1:x*QUNATIZED_MANTISSA_WIDTH] 
      = stage_6_exponent_reg;
    end
  endgenerate
endmodule