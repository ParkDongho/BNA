`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/03/11 16:59:56
// Design Name: 
// Module Name: load_weight_control
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


module load_weight_control
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8,
  parameter WEIGHT_RD_BASE_ADDR = 4'h8,//8

  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  parameter WEIGHT_MEM_ID =2,
  
  //Excute
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15,
  parameter ACCUM_DATA_WIDTH = 32,
  parameter ACCUM_ADDR_WIDTH = 8,
  
  //Activation
  parameter PARAM_ROM_ADDR_WIDTH = 8,
  
  //Store

  parameter VALID_SIZE = 32
)
(
  input wire                          clk, 
  input wire                          rst_n,
  
  ////////////////////////////////////////////////////////////////////////////////////
  //AXI MASTER////////////////////////////////////////////////////////////////////////
  //Read Channels
  //read address
  output wire                         m_axi_weight_memory_bus_ARVALID,
  input  wire                         m_axi_weight_memory_bus_ARREADY,
  output wire [AXI_WIDTH_AD-1:0]      m_axi_weight_memory_bus_ARADDR,
  output wire [AXI_WIDTH_ID-1:0]      m_axi_weight_memory_bus_ARID,
  output wire [7:0]                   m_axi_weight_memory_bus_ARLEN,
  output wire [2:0]                   m_axi_weight_memory_bus_ARSIZE,
  output wire [1:0]                   m_axi_weight_memory_bus_ARBURST,
  output wire [1:0]                   m_axi_weight_memory_bus_ARLOCK,
  output wire [3:0]                   m_axi_weight_memory_bus_ARCACHE,
  output wire [2:0]                   m_axi_weight_memory_bus_ARPROT,
  output wire [3:0]                   m_axi_weight_memory_bus_ARQOS,
  //output wire [3:0]                   m_axi_weight_memory_bus_ARREGION,
  output wire [3:0]                   m_axi_weight_memory_bus_ARUSER,
  /////////////////////////////////////////////////////////////////////////////////////
  //read data//////////////////////////////////////////////////////////////////////////
  input  wire                         m_axi_weight_memory_bus_RVALID,
  output wire                         m_axi_weight_memory_bus_RREADY,
  input  wire                         m_axi_weight_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_weight_memory_bus_RID,
  input  wire [3:0]                   m_axi_weight_memory_bus_RUSER,
  input  wire [1:0]                   m_axi_weight_memory_bus_RRESP,
  /////////////////////////////////////////////////////////////////////////////////////
  //instuction scheduler///////////////////////////////////////////////////////////////
  input wire                          i_load_weight_instruction_fifo_empty, 
  input wire                          i_load_activation_instruction_fifo_full,
  input wire [31:0]                   i_load_weight_instruction_data,
  
  output wire                         o_load_weight_instruction_fifo_rd_en,
  output wire                         o_load_activation_instruction_fifo_wr_en,

  output wire                         o_load_weight_idle,
  /////////////////////////////////////////////////////////////////////////////////////
  //load weight control////////////////////////////////////////////////////////////////
  input  wire                         i_set_weight,
  output wire                         o_load_weight_data_reg_wr_en,          
  output wire [4:0]                   o_sel_load_weight_data,
  output wire                         o_prepare_weight,
  //output wire                         o_weight_data_fifo_wr_en,
  output reg                          o_bias_data_fifo_wr_en,
  output reg                          o_param_data_fifo_wr_en
  /////////////////////////////////////////////////////////////////////////////////////
);


  localparam
    IDLE            = 5'b00001,
    BUSY            = 5'b00010,
    BURSTREAD       = 5'b00100,
    FETCHEX         = 5'b01000,
    FINISH          = 5'b10000;
    
    
    
  reg [4:0]                          state_reg;
  reg [4:0]                          state_nxt;
  
  ////////////////////////////////////////////////////////////////////////////////////
  //AXI MASTER////////////////////////////////////////////////////////////////////////
  //Read Channels
  //read address
  reg                                m_axi_weight_memory_bus_ARVALID_reg;
  reg                                m_axi_weight_memory_bus_ARVALID_nxt;
  reg  [AXI_WIDTH_AD-6-1:0]          m_axi_weight_memory_bus_ARADDR_reg;
  reg  [AXI_WIDTH_AD-6-1:0]          m_axi_weight_memory_bus_ARADDR_nxt;
  reg  [7-5:0]                       m_axi_weight_memory_bus_ARLEN_reg;
  reg  [7-5:0]                       m_axi_weight_memory_bus_ARLEN_nxt;
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //read data////////////////////////////////////////////////////////////////////////
  reg                                m_axi_weight_memory_bus_RREADY_reg;
  reg                                m_axi_weight_memory_bus_RREADY_nxt;
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //instuction scheduler/////////////////////////////////////////////////////////////
  reg                                load_weight_instruction_fifo_rd_en;
  reg                                load_activation_instruction_fifo_wr_en;
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //load weight control//////////////////////////////////////////////////////////////
  reg                                 load_weight_data_reg_wr_en;
  reg [4:0]                           sel_load_weight_data_reg;
  reg [4:0]                           sel_load_weight_data_nxt;
  reg                                 prepare_weight_reg;  
  reg                                 prepare_weight_nxt;
  reg                                 weight_load_bias_mode_reg;
  reg                                 weight_load_bias_mode_nxt;
  reg                                 temp_2nd_burst_reg;
  reg                                 temp_2nd_burst_nxt;

  //reg                                 weight_data_fifo_wr_en_reg;
  //reg                                 weight_data_fifo_wr_en_nxt;
  reg                                 bias_data_fifo_wr_en_reg;
  reg                                 bias_data_fifo_wr_en_nxt;
  reg                                 param_data_fifo_wr_en_reg;
  reg                                 param_data_fifo_wr_en_nxt;  
  ///////////////////////////////////////////////////////////////////////////////////

  reg                                 ready;
  
  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      state_reg <= IDLE;
      m_axi_weight_memory_bus_ARVALID_reg <= 'd0;
      m_axi_weight_memory_bus_ARADDR_reg <= 'd0;
      m_axi_weight_memory_bus_ARLEN_reg <= 'd0;
      m_axi_weight_memory_bus_RREADY_reg <= 'd0;

      sel_load_weight_data_reg <= 'd0;
      prepare_weight_reg <= 'd0; 
      weight_load_bias_mode_reg <= 'd0;
      temp_2nd_burst_reg <= 'd0;

      //weight_data_fifo_wr_en_reg <= 'd0;
      bias_data_fifo_wr_en_reg <= 'd0;
      param_data_fifo_wr_en_reg <= 'd0;  

      o_bias_data_fifo_wr_en <= 'd0;
      o_param_data_fifo_wr_en <= 'd0;  
    end
    else
    begin
      state_reg <= state_nxt;
      m_axi_weight_memory_bus_ARVALID_reg <= m_axi_weight_memory_bus_ARVALID_nxt;
      m_axi_weight_memory_bus_ARADDR_reg <= m_axi_weight_memory_bus_ARADDR_nxt;
      m_axi_weight_memory_bus_ARLEN_reg <= m_axi_weight_memory_bus_ARLEN_nxt;
      m_axi_weight_memory_bus_RREADY_reg <= m_axi_weight_memory_bus_RREADY_nxt;

      sel_load_weight_data_reg <= sel_load_weight_data_nxt;
      prepare_weight_reg <= prepare_weight_nxt; 
      weight_load_bias_mode_reg <= weight_load_bias_mode_nxt;
      temp_2nd_burst_reg <=  temp_2nd_burst_nxt;

      //weight_data_fifo_wr_en_reg <= weight_data_fifo_wr_en_nxt;
      bias_data_fifo_wr_en_reg <= bias_data_fifo_wr_en_nxt;
      param_data_fifo_wr_en_reg <= param_data_fifo_wr_en_nxt;  

      o_bias_data_fifo_wr_en <= bias_data_fifo_wr_en_reg;
      o_param_data_fifo_wr_en <= param_data_fifo_wr_en_reg;
    end
  end

  always @(*)
  begin

    load_weight_instruction_fifo_rd_en = 1'b0;
    load_activation_instruction_fifo_wr_en = 1'b0;
    state_nxt = state_reg;
    m_axi_weight_memory_bus_ARVALID_nxt = m_axi_weight_memory_bus_ARVALID_reg;
    m_axi_weight_memory_bus_ARADDR_nxt = m_axi_weight_memory_bus_ARADDR_reg;
    m_axi_weight_memory_bus_ARLEN_nxt = m_axi_weight_memory_bus_ARLEN_reg;
    m_axi_weight_memory_bus_RREADY_nxt = m_axi_weight_memory_bus_RREADY_reg;

    load_weight_data_reg_wr_en = 1'b0;
    sel_load_weight_data_nxt = sel_load_weight_data_reg;
    prepare_weight_nxt = 1'b0; 
    weight_load_bias_mode_nxt = weight_load_bias_mode_reg;
    temp_2nd_burst_nxt = temp_2nd_burst_reg;

    //weight_data_fifo_wr_en_nxt = 1'b0;
    bias_data_fifo_wr_en_nxt = 1'b0;
    param_data_fifo_wr_en_nxt = 1'b0;  

    case (state_reg)
      ///////////////////////////////////////////////////////////////////////////////
      //IDLE/////////////////////////////////////////////////////////////////////////
      //
      IDLE:
      begin
        if(!i_load_weight_instruction_fifo_empty)
        begin
          if(i_load_weight_instruction_data[31:29] == 3'b001)
          begin //load_weight instruction
            if(ready)
            begin
              state_nxt = BUSY;
              //instruction fetch
              load_weight_instruction_fifo_rd_en = 1'b1;
              m_axi_weight_memory_bus_ARVALID_nxt = 1'b1;
              m_axi_weight_memory_bus_ARADDR_nxt = i_load_weight_instruction_data[25:0];
              weight_load_bias_mode_nxt = i_load_weight_instruction_data[28];
              m_axi_weight_memory_bus_ARLEN_nxt = 3'b111;
              temp_2nd_burst_nxt = 1'b0;
            end         
          end
          else if(i_load_weight_instruction_data[31:29] == 3'b010) 
          begin //execute instruction
            if(!i_load_activation_instruction_fifo_full)
            begin //fetch higher execute instruction
              state_nxt = FETCHEX;
              load_weight_instruction_fifo_rd_en = 1'b1;
              load_activation_instruction_fifo_wr_en = 1'b1;
            end
          end
          else
          begin //load_activation, writeback, store_activation instruction
            if(!i_load_activation_instruction_fifo_full)
            begin
              load_weight_instruction_fifo_rd_en = 1'b1;
              load_activation_instruction_fifo_wr_en = 1'b1;
            end
          end
        end
      end
      //
      ///////////////////////////////////////////////////////////////////////////////
    
      ///////////////////////////////////////////////////////////////////////////////
      //BUSY/////////////////////////////////////////////////////////////////////////
      //
      BUSY:
      begin
        if(m_axi_weight_memory_bus_ARREADY) //wait ARREADY
        begin
          state_nxt = BURSTREAD;
          m_axi_weight_memory_bus_ARVALID_nxt = 1'b0;
          m_axi_weight_memory_bus_RREADY_nxt = 1'b1;
          sel_load_weight_data_nxt = 5'b0;
        end
      end
      //
      ///////////////////////////////////////////////////////////////////////////////

      ///////////////////////////////////////////////////////////////////////////////
      //BURST READ///////////////////////////////////////////////////////////////////
      //
      BURSTREAD:
      begin
        if(m_axi_weight_memory_bus_RVALID & //wait rvalid
          (m_axi_weight_memory_bus_RID == WEIGHT_MEM_ID) & //read id
          (!m_axi_weight_memory_bus_RRESP[1])) //response : ok
        begin
          sel_load_weight_data_nxt = sel_load_weight_data_reg + 1;
          load_weight_data_reg_wr_en = 1'b1;
          if(sel_load_weight_data_reg == 5'b11111)
          begin
            prepare_weight_nxt = 1'b1; //delayed 1 cycle
            if(m_axi_weight_memory_bus_RLAST) //last data
            begin
              if(temp_2nd_burst_reg)
              begin
                state_nxt = IDLE;
                m_axi_weight_memory_bus_RREADY_nxt = 1'b0;
                temp_2nd_burst_nxt = 1'b0;
                
                //weight_data_fifo_wr_en_nxt = 1'b1;
                bias_data_fifo_wr_en_nxt = weight_load_bias_mode_reg;
                param_data_fifo_wr_en_nxt = weight_load_bias_mode_reg;
              end
              else
              begin
                state_nxt = BUSY;
                temp_2nd_burst_nxt = 1'b1;
                m_axi_weight_memory_bus_RREADY_nxt = 1'b0;
                m_axi_weight_memory_bus_ARVALID_nxt = 1'b1;
                m_axi_weight_memory_bus_ARADDR_nxt
                  = {(m_axi_weight_memory_bus_ARADDR_reg[25:8] + 1'b1), 
                      m_axi_weight_memory_bus_ARADDR_reg[7:0]}; 
                if(weight_load_bias_mode_reg)
                begin
                  m_axi_weight_memory_bus_ARLEN_nxt = 3'b011;
                end
                else
                begin
                  m_axi_weight_memory_bus_ARLEN_nxt = 3'b000;
                end
              end
            end
          end
        end
      end
      //
      ////////////////////////////////////////////////////////////////////////////////

      ////////////////////////////////////////////////////////////////////////////////
      //FETCH LOWER EXECUTE INSTRUCTION///////////////////////////////////////////////
      //
      FETCHEX:
      begin
        if((!i_load_weight_instruction_fifo_empty)&(!i_load_activation_instruction_fifo_full))
        begin
          state_nxt = IDLE;
          load_weight_instruction_fifo_rd_en = 1'b1;
          load_activation_instruction_fifo_wr_en = 1'b1;
        end
      end
      //
      ////////////////////////////////////////////////////////////////////////////////
    endcase
  end

  always @(posedge clk)
  begin
    if(rst_n == 1'b0)
    begin
      ready <= 1'b1;
    end
    else
    begin
      if(i_set_weight)
      begin
        ready <= 1'b1;
      end
      else
      begin
        if(state_reg == BUSY)
        begin
          ready <= 1'b0;
        end
      end
    end
  end
  
  ////////////////////////////////////////////////////////////////////////////////////
  //AXI MASTER////////////////////////////////////////////////////////////////////////
  //Read Channels
  //read address
  assign m_axi_weight_memory_bus_ARVALID = m_axi_weight_memory_bus_ARVALID_reg;
  assign m_axi_weight_memory_bus_ARADDR = {WEIGHT_RD_BASE_ADDR, m_axi_weight_memory_bus_ARADDR_reg, 2'b0};
  assign m_axi_weight_memory_bus_ARID = WEIGHT_MEM_ID;
  assign m_axi_weight_memory_bus_ARLEN = {m_axi_weight_memory_bus_ARLEN_reg, 5'b11111};
  assign m_axi_weight_memory_bus_ARSIZE = 3'b010; //4Byte(32bit)
  assign m_axi_weight_memory_bus_ARBURST = 2'b01; //increment mode

  assign m_axi_weight_memory_bus_ARLOCK = 2'b00; //not used
  assign m_axi_weight_memory_bus_ARCACHE = 4'b0000; //not used
  assign m_axi_weight_memory_bus_ARPROT = 3'b000; //not used
  assign m_axi_weight_memory_bus_ARQOS = 4'b0000; //not used
  //assign m_axi_weight_memory_bus_ARREGION = 4'b0000; //not used
  assign m_axi_weight_memory_bus_ARUSER = 4'b0000; //not used
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //read data////////////////////////////////////////////////////////////////////////
  assign m_axi_weight_memory_bus_RREADY = m_axi_weight_memory_bus_RREADY_reg;
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //instuction scheduler/////////////////////////////////////////////////////////////
  assign o_load_weight_instruction_fifo_rd_en = load_weight_instruction_fifo_rd_en;
  assign o_load_activation_instruction_fifo_wr_en = load_activation_instruction_fifo_wr_en;
  ///////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////
  //load weight control//////////////////////////////////////////////////////////////
  assign o_load_weight_data_reg_wr_en = load_weight_data_reg_wr_en;
  assign o_sel_load_weight_data = sel_load_weight_data_reg;
  assign o_prepare_weight = prepare_weight_reg;

  //assign o_weight_data_fifo_wr_en = weight_data_fifo_wr_en_reg;
  //assign o_bias_data_fifo_wr_en = bias_data_fifo_wr_en_reg;
  //assign o_param_data_fifo_wr_en = param_data_fifo_wr_en_reg;  
  ///////////////////////////////////////////////////////////////////////////////////
  assign o_load_weight_idle = state_reg[0];
  
endmodule
