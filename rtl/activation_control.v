`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/27 18:43:48
// Design Name: 
// Module Name: activation_control
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


module activation_control
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8,

  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  
  //Excute
  parameter WEIGHT_RAM_ADDR_WIDTH = 4,
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15,
  parameter ACCUM_DATA_WIDTH = 32,
  parameter ACCUM_ADDR_WIDTH = 8,
  
  //Activation
  parameter PARAM_ROM_ADDR_WIDTH = 8
  
  //Store
)
(
  input wire                                clk, 
  input wire                                rst_n,
  //============================================================================
  
  input wire                                i_activation_instruction_fifo_empty, 
  input wire                                i_store_instruction_fifo_full,
  input wire [31:0]                         i_activation_instruction_data,
  
  output wire                               o_activation_instruction_fifo_rd_en,
  output wire                               o_store_instruction_fifo_wr_en,

  output wire                               o_activation_idle,

  //============================================================================
  //alu control 
  output wire [3:0]                         o_vetor_unit_op,
  output wire                               o_set_param,
  //execute final fifo control
  input  wire                               i_execute_out_fifo_empty, 
  output wire                               o_execute_out_fifo_rd_en,
  //activation accum fifo control
  input  wire                               i_activation_accum_fifo_empty, 
  input  wire                               i_activation_accum_fifo_full,
  output wire                               o_activation_accum_fifo_rd_en, 
  output wire                               o_activation_accum_fifo_wr_en,
  //activation final fifo control
  input  wire                               i_activation_out_fifo_full,
  output wire                               o_activation_out_fifo_wr_en
  //===========================================================================
);

  localparam      
  IDLE          = 3'b001,
  BUSY          = 3'b010,
  WAITVALID     = 3'b100;

  reg [2:0]                                state_reg;
  reg [2:0]                                state_nxt;

  
  reg                                      activation_instruction_fifo_rd_en;
  reg                                      store_instruction_fifo_wr_en;
  //============================================================================
  //alu control 
  reg [3:0]                                vetor_unit_op_reg;
  reg [3:0]                                vetor_unit_op_nxt;
  reg                                      set_param_reg;
  reg                                      set_param_nxt;
  //execute final fifo control 
  reg                                      execute_out_fifo_rd_en_reg;
  reg                                      execute_out_fifo_rd_en_nxt;
  reg                                      execute_out_fifo_rd_en_tmp_reg;
  //activation accum fifo control 
  reg                                      activation_accum_fifo_rd_en_reg;
  reg                                      activation_accum_fifo_rd_en_nxt; 
  reg                                      activation_accum_fifo_wr_en_reg;
  reg                                      activation_accum_fifo_wr_en_nxt;
  //activation final fifo control
  reg                                      activation_out_fifo_wr_en_reg;
  reg                                      activation_out_fifo_wr_en_nxt;  
  //===========================================================================
  
  reg [7:0]                                counter_ptr_reg;
  reg [7:0]                                counter_ptr_nxt;

  reg                                      busy;
  wire                                     valid;

  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      state_reg <= IDLE; 
      vetor_unit_op_reg <= 'd0;
      set_param_reg <= 'd0;
      execute_out_fifo_rd_en_reg <= 'd0;
      execute_out_fifo_rd_en_tmp_reg <= 'd0;
      activation_accum_fifo_rd_en_reg <= 'd0;
      activation_accum_fifo_wr_en_reg <= 'd0;
      activation_out_fifo_wr_en_reg <= 'd0;
      counter_ptr_reg <= 'd0;
    end
    else
    begin
      state_reg <= state_nxt; 
      vetor_unit_op_reg <= vetor_unit_op_nxt;
      set_param_reg <= set_param_nxt;
      execute_out_fifo_rd_en_reg <= execute_out_fifo_rd_en_nxt;
      execute_out_fifo_rd_en_tmp_reg <= execute_out_fifo_rd_en_reg;
      activation_accum_fifo_rd_en_reg <= activation_accum_fifo_rd_en_nxt;
      activation_accum_fifo_wr_en_reg <= activation_accum_fifo_wr_en_nxt;
      activation_out_fifo_wr_en_reg <= activation_out_fifo_wr_en_nxt;
      counter_ptr_reg <= counter_ptr_nxt;      
    end
  end
  

  always @(*) 
  begin
    busy = 1'b0;
    state_nxt = state_reg;
    vetor_unit_op_nxt = vetor_unit_op_reg;
    set_param_nxt = 1'b0;
    execute_out_fifo_rd_en_nxt = execute_out_fifo_rd_en_reg;
    activation_accum_fifo_rd_en_nxt = activation_accum_fifo_rd_en_reg;
    activation_accum_fifo_wr_en_nxt = activation_accum_fifo_wr_en_reg;
    activation_out_fifo_wr_en_nxt = activation_out_fifo_wr_en_reg;
    counter_ptr_nxt = counter_ptr_reg;

    activation_instruction_fifo_rd_en = 1'b0;
    store_instruction_fifo_wr_en = 1'b0;
    case(state_reg)  
      IDLE:
      begin
        if(!i_activation_instruction_fifo_empty)
        begin
          if(i_activation_instruction_data[31:29] == 3'b011)
          begin
            state_nxt = BUSY;
            activation_instruction_fifo_rd_en = 1'b1;
            vetor_unit_op_nxt = i_activation_instruction_data[24:21];
            set_param_nxt = i_activation_instruction_data[25];
            activation_accum_fifo_rd_en_nxt = i_activation_instruction_data[22]; //read alu fifo when vector_unit_op[1] is high
            activation_accum_fifo_wr_en_nxt = ~i_activation_instruction_data[27]; //final mode
            activation_out_fifo_wr_en_nxt = i_activation_instruction_data[27]; //final mode
            counter_ptr_nxt = i_activation_instruction_data[10:3];
            execute_out_fifo_rd_en_nxt = 1'b1; //alu op 
          end
          else
          begin
            if(!i_store_instruction_fifo_full)
            begin
              //other instruction fetch
              activation_instruction_fifo_rd_en = 1'b1;
              store_instruction_fifo_wr_en = 1'b1;
            end
          end
        end
      end
      BUSY:
      begin
        if(!i_activation_accum_fifo_full)
        begin
          if(counter_ptr_reg != 10'b0)
          begin
            counter_ptr_nxt = counter_ptr_reg - 1;
          end
          else
          begin
            state_nxt = WAITVALID;
            busy = 1'b1;
            activation_accum_fifo_rd_en_nxt = 1'b0;
            activation_accum_fifo_wr_en_nxt = 1'b0;
            activation_out_fifo_wr_en_nxt = 1'b0;
            execute_out_fifo_rd_en_nxt = 1'b0;
          end
        end
      end

      WAITVALID:
      begin
        if(valid)
        begin
          state_nxt = IDLE;
        end
      end
    endcase
  end

  variable_length_shift_register
  #(
    .DATA_WIDTH(2),
    .DELAY(12) 
  ) activation_wr_control_signal_delay
  ( 
    .clk(clk),
    .rst_n(rst_n),
    .i_data(
    {
      activation_accum_fifo_wr_en_reg, 
      activation_out_fifo_wr_en_reg
    }),
    .o_data(
    {
      o_activation_accum_fifo_wr_en, 
      o_activation_out_fifo_wr_en
    })
  );

  variable_length_shift_register
  #(
    .DATA_WIDTH(1),
    .DELAY(6) 
  ) activation_rd_control_signal_delay
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data(activation_accum_fifo_rd_en_reg),
    .o_data(o_activation_accum_fifo_rd_en)
  );

  variable_length_shift_register
  #(
    .DATA_WIDTH(1),
    .DELAY(7) 
  ) activation_valid
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data(busy),
    .o_data(valid)
  );

  assign o_vetor_unit_op = vetor_unit_op_reg;
  assign o_set_param = set_param_reg;
  assign o_execute_out_fifo_rd_en = execute_out_fifo_rd_en_tmp_reg;

  assign o_activation_instruction_fifo_rd_en = activation_instruction_fifo_rd_en;
  assign o_store_instruction_fifo_wr_en = store_instruction_fifo_wr_en;

  assign o_activation_idle = state_reg[0];
endmodule
