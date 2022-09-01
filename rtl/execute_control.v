`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/27 18:43:21
// Design Name: 
// Module Name: execute_control
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


module execute_control
#(
  parameter                                       QUNATIZED_MANTISSA_WIDTH = 7,
  parameter                                       EXPONENT_WIDTH = 8,

  parameter                                       AXI_WIDTH_USER =1,              // Master ID
  parameter                                       AXI_WIDTH_ID   =4,              // ID width in bits
  parameter                                       AXI_WIDTH_AD   =32,             // address width
  parameter                                       AXI_WIDTH_DA   =32,             // data width
  parameter                                       AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter                                       AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter                                       AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter                                       AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  
  //Excute
  parameter                                       MAC_ACC_WIDTH = 48,
  parameter                                       BUFFER_ADDR_WIDTH = 15,
  parameter                                       ACCUM_DATA_WIDTH = 32,
  parameter                                       ACCUM_ADDR_WIDTH = 8,
  parameter                                       BIAS_ROM_ADDR = 8,
  
  //Activation
  parameter                                       PARAM_ROM_ADDR_WIDTH = 8
  
  //Store
  
)
(
  input  wire                                     clk, 
  input  wire                                     rst_n,
  //============================================================================
  //instuction scheduler
  input  wire                                     i_execute_instruction_fifo_empty, 
  input  wire                                     i_activation_instruction_fifo_full,
  input  wire [31:0]                              i_execute_instruction_data,
  output wire                                     o_execute_instruction_fifo_rd_en,
  output wire                                     o_activation_instruction_fifo_wr_en,

  output wire                                     o_execute_idle,

  //============================================================================
  //activation buffer control
  output wire                                     o_activation_rd_en, //activation buffer read enable
  output wire [BUFFER_ADDR_WIDTH-1:0]             o_buffer_rd_addr, //buffer address
  
  //============================================================================
  //systolic array control
  output wire                                     o_set_weight, //set prepared weight

  //============================================================================
  //accumulator control
  output wire                                     o_bias_mode,
  output wire                                     o_accum_rd_en, 
  output wire                                     o_accum_wr_en,
  output wire [ACCUM_ADDR_WIDTH-1:0]              o_accum_addr, 
  output wire                                     o_set_bias,
  //accumulator fifo control
  input  wire                                     i_execute_out_fifo_full, //final data
  output wire                                     o_execute_out_fifo_wr_en //final data
);

  localparam
    IDLE          = 5'b00001,
    BUSY          = 5'b00010,
    FETCHEXE      = 5'b00100,
    WAITVALID     = 5'b01000,
    WAITFINISH    = 5'b10000;
  
  //Signal Declaration
  reg [4:0]                                     state_reg;
  reg [4:0]                                     state_nxt;
  //============================================================================
  //instuction scheduler
  reg                                           execute_instruction_fifo_rd_en;
  reg                                           activation_instruction_fifo_wr_en;

  //============================================================================
  //activation buffer control
  reg                                           activation_rd_en_reg; //activation buffer read enable
  reg                                           activation_rd_en_nxt; //activation buffer read enable next
  reg [BUFFER_ADDR_WIDTH-1:0]                   buffer_rd_addr_reg; //buffer address
  reg [BUFFER_ADDR_WIDTH-1:0]                   buffer_rd_addr_nxt; //buffer address next

  
  //============================================================================
  //systolic array control
  reg                                           set_weight_reg; //set prepared weight
  reg                                           set_weight_nxt; //set prepared weight


  //============================================================================
  //accumulator control
  reg                                           bias_mode_reg;
  reg                                           bias_mode_nxt;
  reg                                           bias_mode_inst_reg;
  reg                                           bias_mode_inst_nxt;
  reg                                           accum_rd_en_reg;
  reg                                           accum_rd_en_nxt;
  reg                                           accum_wr_en_reg;
  reg                                           accum_wr_en_nxt;
  reg [ACCUM_ADDR_WIDTH-1:0]                    accum_addr_reg; //CHANGE ADDR
  reg [ACCUM_ADDR_WIDTH-1:0]                    accum_addr_nxt; //CHANGE ADDR
  reg                                           set_bias_reg;
  reg                                           set_bias_nxt;
  //accumulator fifo control
  reg                                           execute_out_fifo_wr_en_reg; //final data
  reg                                           execute_out_fifo_wr_en_nxt; //final data

  reg                                           final_mode_inst_reg;
  reg                                           final_mode_inst_nxt;
  
  //============================================================================
  
  reg [7:0]                                     counter0_inst_nxt;
  reg [7:0]                                     counter0_inst_reg;
  reg [7:0]                                     counter0_ptr_nxt;
  reg [7:0]                                     counter0_ptr_reg;  
  
  reg [7:0]                                     counter1_inst_nxt;
  reg [7:0]                                     counter1_inst_reg;
  reg [7:0]                                     counter1_ptr_nxt;
  reg [7:0]                                     counter1_ptr_reg;  
  
  reg [4:0]                                     buffer_inc_inst_nxt;
  reg [4:0]                                     buffer_inc_inst_reg;
  reg [4:0]                                     accum_inc_inst_nxt;
  reg [4:0]                                     accum_inc_inst_reg;
  
  wire [BUFFER_ADDR_WIDTH-1:0]                  buffer_inc;
  wire [BUFFER_ADDR_WIDTH-1:0]                  accum_inc;
  reg  [9:0]                                    buffer_inc_param;
  reg  [9:0]                                    accum_inc_param;
  
  wire                                          valid;
  reg                                           busy;
  
  always @(posedge clk)
  begin
    if (rst_n==1'b0) 
    begin
      state_reg <= IDLE;
      //============================================================================
      //activation buffer control
      activation_rd_en_reg <= 'd0; //activation buffer read enable
      buffer_rd_addr_reg <= 'd0; //buffer address
      
      //============================================================================
      //systolic array control
      set_weight_reg <= 'd0; //set prepared weight

      //============================================================================
      //accumulator control
      bias_mode_reg <= 'd0;
      bias_mode_inst_reg <= 'd0;
      accum_rd_en_reg <= 'd0;
      accum_wr_en_reg <= 'd0;
      accum_addr_reg <= 'd0; 
      set_bias_reg <= 'd0;
      //accumulator fifo control
      execute_out_fifo_wr_en_reg <= 'd0; //final data
      final_mode_inst_reg <= 'd0;
      //////////////////////////////////////////////////////////////////////////////
      counter0_inst_reg <= 'd0;        
      counter0_ptr_reg <= 'd0;
      counter1_inst_reg <= 'd0;
      counter1_ptr_reg <= 'd0; 
      buffer_inc_inst_reg <= 'd0;
      accum_inc_inst_reg <= 'd0;
    end
    else
    begin
      //Signal Declaration
      state_reg <= state_nxt;
      //============================================================================
      //activation buffer control
      activation_rd_en_reg <= activation_rd_en_nxt; //activation buffer read enable next
      buffer_rd_addr_reg <= buffer_rd_addr_nxt; //buffer address next

      
      //============================================================================
      //systolic array control
      set_weight_reg <= set_weight_nxt; //set prepared weight


      //============================================================================
      //accumulator control
      bias_mode_reg <= bias_mode_nxt;
      bias_mode_inst_reg <= bias_mode_inst_nxt;
      accum_rd_en_reg <= accum_rd_en_nxt;
      accum_wr_en_reg <= accum_wr_en_nxt;
      accum_addr_reg <= accum_addr_nxt; //CHANGE ADDR
      set_bias_reg <= set_bias_nxt;
      //accumulator fifo control
      execute_out_fifo_wr_en_reg <= execute_out_fifo_wr_en_nxt; //final data
      final_mode_inst_reg <= final_mode_inst_nxt;
      //============================================================================
    
      counter0_inst_reg <= counter0_inst_nxt;        
      counter0_ptr_reg <= counter0_ptr_nxt;
      counter1_inst_reg <= counter1_inst_nxt;
      counter1_ptr_reg <= counter1_ptr_nxt; 
      buffer_inc_inst_reg <= buffer_inc_inst_nxt;
      accum_inc_inst_reg <= accum_inc_inst_nxt;
    end
  end

  always @(*)
  begin
    busy = 1'b0;
    state_nxt = state_reg;
    //============================================================================
    //instuction scheduler
    execute_instruction_fifo_rd_en = 1'b0;
    activation_instruction_fifo_wr_en = 1'b0;

    //============================================================================
    //activation buffer control
    activation_rd_en_nxt = activation_rd_en_reg; //activation buffer read enable next
    buffer_rd_addr_nxt = buffer_rd_addr_reg; //buffer address next

    
    //============================================================================
    //systolic array control
    set_weight_nxt = 1'b0; //set prepared weight

    //============================================================================
    //accumulator control
    bias_mode_nxt = bias_mode_reg;
    bias_mode_inst_nxt = bias_mode_inst_reg;
    accum_rd_en_nxt = accum_rd_en_reg;
    accum_wr_en_nxt = accum_wr_en_reg;
    accum_addr_nxt = accum_addr_reg; //CHANGE ADDR
    set_bias_nxt = 1'b0;
    //accumulator fifo control
    execute_out_fifo_wr_en_nxt = execute_out_fifo_wr_en_reg; //final data
    final_mode_inst_nxt = final_mode_inst_reg;
    //============================================================================
  
    counter0_inst_nxt = counter0_inst_reg;
    counter0_ptr_nxt = counter0_ptr_reg;
    counter1_inst_nxt = counter1_inst_reg;
    counter1_ptr_nxt = counter1_ptr_reg; 
    buffer_inc_inst_nxt = buffer_inc_inst_reg;
    accum_inc_inst_nxt = accum_inc_inst_reg;
    buffer_inc_param = 'd0;
    accum_inc_param = 'd0;

    case (state_reg)
      IDLE:
      begin
        if(!i_execute_instruction_fifo_empty) 
        begin
          if(i_execute_instruction_data[31:29] == 3'b010) //execute
          begin
            state_nxt = FETCHEXE;
            execute_instruction_fifo_rd_en = 1'b1;
            //high execute instrction fetch
            bias_mode_nxt              = i_execute_instruction_data[28];
            bias_mode_inst_nxt         = i_execute_instruction_data[28]; //bias mode instruction
            final_mode_inst_nxt        = i_execute_instruction_data[27];
            set_weight_nxt             = i_execute_instruction_data[26]; //set weight
            set_bias_nxt               = i_execute_instruction_data[25]; //set bias
            
            accum_addr_nxt              = i_execute_instruction_data[24:13];
            counter0_inst_nxt           = i_execute_instruction_data[12:5];
            counter0_ptr_nxt            = i_execute_instruction_data[12:5];
            accum_inc_inst_nxt          = i_execute_instruction_data[4:0];
          end
          else
          begin
            if(!i_activation_instruction_fifo_full)
            begin
              execute_instruction_fifo_rd_en = 1'b1; 
              activation_instruction_fifo_wr_en = 1'b1;
            end
          end        
        end
      end

      FETCHEXE:
      begin
        if(!i_execute_instruction_fifo_empty)
        begin
          state_nxt = BUSY;
          execute_instruction_fifo_rd_en = 1'b1;
          //low execute instruction fetch
          execute_out_fifo_wr_en_nxt = final_mode_inst_reg; //final
          accum_wr_en_nxt           = !final_mode_inst_reg; //accum
          accum_rd_en_nxt           = !bias_mode_inst_reg; //bias mode
          activation_rd_en_nxt      = 1'b1;
          
          buffer_rd_addr_nxt     = i_execute_instruction_data[30:13];
          counter1_inst_nxt      = i_execute_instruction_data[12:5];
          counter1_ptr_nxt       = i_execute_instruction_data[12:5];
          buffer_inc_inst_nxt    = i_execute_instruction_data[4:0];
        end
      end

      BUSY:
      begin
        if(counter0_ptr_reg != 'b0) //1st layer
        begin
          counter0_ptr_nxt = counter0_ptr_reg - 1;
          buffer_inc_param = (buffer_inc_inst_reg[4] ? 2'b10:2'b01);
          accum_inc_param = (accum_inc_inst_reg[4] ? 2'b10:2'b01);
          buffer_rd_addr_nxt = buffer_inc;
          accum_addr_nxt = accum_inc;
        end
        else
        begin
          if(counter1_ptr_reg != 'b0) //2nd layer
          begin
            counter1_ptr_nxt = counter1_ptr_reg - 1;
            counter0_ptr_nxt = counter0_inst_reg;
            if(buffer_inc_inst_reg[4])
              buffer_inc_param = ((((counter0_inst_reg + 1) + buffer_inc_inst_reg[3:2])<<1'b1)+buffer_inc_inst_reg[1:0]);
            else 
              buffer_inc_param = buffer_inc_inst_reg[1:0];
            if(accum_inc_inst_reg[4])
              accum_inc_param = ((((counter0_inst_reg + 1) + accum_inc_inst_reg[3:2])<<1'b1)+accum_inc_inst_reg[1:0]);
            else
              accum_inc_param = accum_inc_inst_reg[1:0];

            buffer_rd_addr_nxt = buffer_inc;
            accum_addr_nxt = accum_inc;
          end
          else //final if coutner1_ptr_reg == 0
          begin
            state_nxt = WAITFINISH;
            execute_out_fifo_wr_en_nxt = 1'b0;
            accum_wr_en_nxt = 1'b0;
            accum_rd_en_nxt = 1'b0;
            activation_rd_en_nxt = 1'b0;
            if({i_execute_instruction_data[31:29], i_execute_instruction_data[26:25]} == 5'b01000)
            begin
              state_nxt = IDLE;
            end
            else
            begin
              busy = 1'b1;
              state_nxt = WAITFINISH;
            end
          end
        end 
      end

      WAITFINISH:
      begin
        if(valid)
        begin
          state_nxt = IDLE;
        end
      end

      default : state_nxt = IDLE;
    endcase
  end

  variable_length_shift_register
  #(
    .DATA_WIDTH(ACCUM_ADDR_WIDTH+3),
    .DELAY(19) 
  ) accumulator_control_signal_delay_0
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data({
    accum_rd_en_reg,
    accum_wr_en_reg,
    accum_addr_reg,
    execute_out_fifo_wr_en_reg
    }),
    .o_data({
    o_accum_rd_en,
    o_accum_wr_en,
    o_accum_addr,
    o_execute_out_fifo_wr_en
    })
  );

    variable_length_shift_register
  #(
    .DATA_WIDTH(2),
    .DELAY(19) 
  ) accumulator_control_signal_delay_1
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data({
    bias_mode_reg,
    set_bias_reg
    }),
    .o_data({
    o_bias_mode,
    o_set_bias
    })
  );

  variable_length_shift_register
  #(
    .DATA_WIDTH(1),
    .DELAY(40) 
  ) execute_valid
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data(busy),
    .o_data(valid)
  );

  //assignment
  assign  buffer_inc = buffer_rd_addr_reg + buffer_inc_param;
  assign  accum_inc = accum_addr_reg + accum_inc_param;

  //============================================================================
  //instuction scheduler
  assign o_execute_instruction_fifo_rd_en = execute_instruction_fifo_rd_en;
  assign o_activation_instruction_fifo_wr_en = activation_instruction_fifo_wr_en;

  //============================================================================
  //activation buffer control
  assign o_activation_rd_en = activation_rd_en_reg;//activation buffer read enable
  assign o_buffer_rd_addr = buffer_rd_addr_reg;//buffer address
  
  //============================================================================
  //systolic array control
  assign o_set_weight = set_weight_reg;//set prepared weight
  //============================================================================
  assign o_execute_idle = state_reg[0];

endmodule
