`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/27 18:44:10
// Design Name: 
// Module Name: store_control
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


module store_control
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8,
  parameter ACTIVATION_WR_BASE_ADDR = 4'h8,

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
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15,
  parameter ACCUM_DATA_WIDTH = 32,
  parameter ACCUM_ADDR_WIDTH = 8,
  
  //Activation
  parameter PARAM_ROM_ADDR_WIDTH = 8
  
  //Store
)
(
  input wire clk, rst_n,

  //AXI MASTER////////////////////////////////////////////////////////////////////
  //Write Channels
  //write address
  output wire                         m_axi_memory_bus_AWVALID,
  input  wire                         m_axi_memory_bus_AWREADY,
  output wire [AXI_WIDTH_AD-1:0]      m_axi_memory_bus_AWADDR,
  output wire [AXI_WIDTH_ID-1:0]      m_axi_memory_bus_AWID,
  output wire [7:0]                   m_axi_memory_bus_AWLEN,
  output wire [2:0]                   m_axi_memory_bus_AWSIZE,
  output wire [1:0]                   m_axi_memory_bus_AWBURST,
  output wire [1:0]                   m_axi_memory_bus_AWLOCK,
  output wire [3:0]                   m_axi_memory_bus_AWCACHE,
  output wire [2:0]                   m_axi_memory_bus_AWPROT,
  output wire [3:0]                   m_axi_memory_bus_AWQOS,
  //output wire [3:0]                   m_axi_memory_bus_AWREGION,
  output wire [3:0]                   m_axi_memory_bus_AWUSER,

  //write data
  output wire                         m_axi_memory_bus_WVALID,
  input  wire                         m_axi_memory_bus_WREADY,
  output wire [AXI_WIDTH_DS-1:0]      m_axi_memory_bus_WSTRB,
  output wire                         m_axi_memory_bus_WLAST,
  //output wire [AXI_WIDTH_ID-1:0]      m_axi_memory_bus_WID,
  output wire [3:0]                   m_axi_memory_bus_WUSER,

  //write response
  input  wire                         m_axi_memory_bus_BVALID,
  output wire                         m_axi_memory_bus_BREADY,
  input  wire [1:0]                   m_axi_memory_bus_BRESP,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_memory_bus_BID,
  input  wire                         m_axi_memory_bus_BUSER,
 
  //Instruction fetch control/////////////////////////////////////////////////////
  input  wire                         i_store_instruction_fifo_empty,
  input  wire [31:0]                  i_store_instruction_data,
  output wire                         o_store_instruction_fifo_rd_en,

  output wire                         o_store_idle,
  //Write back control///////////////////////////////////////////////////////////
  input  wire                         i_write_back_finish,
  output wire                         o_write_back_req,
  
  //Store Control Signals///////////////////////////////////////////////////////
  input   wire                        i_activation_out_fifo_empty,
  output  wire                        o_activation_out_fifo_rd_en,
  output  wire                        o_store_data_reg_wr_en,
  output  wire [4:0]                  o_sel_store_data
  /////////////////////////////////////////////////////////////////////////////
);

  localparam
  IDLE                             = 8'b00000001,
  BUSYWB                           = 8'b00000010,
  BUSYSTOR                         = 8'b00000100,
  BURSTWRITE                       = 8'b00001000,
  BURSTLAST                        = 8'b00010000,
  BURSTRESP                        = 8'b00100000,
  WAIT                             = 8'b01000000,
  WAIT2                            = 8'b10000000;

  reg [7:0]                          state_reg;
  reg [7:0]                          state_nxt;

  //AXI MASTER////////////////////////////////////////////////////////////////
  //Write Channels
  //write address
  reg                                m_axi_memory_bus_AWVALID_reg;
  reg                                m_axi_memory_bus_AWVALID_nxt;
  reg [AXI_WIDTH_AD-1-6:0]           m_axi_memory_bus_AWADDR_reg;
  reg [AXI_WIDTH_AD-1-6:0]           m_axi_memory_bus_AWADDR_nxt;
  reg [7-5:0]                        m_axi_memory_bus_AWLEN_reg;
  reg [7-5:0]                        m_axi_memory_bus_AWLEN_nxt;

  //write data
  reg                                m_axi_memory_bus_WVALID_reg;
  reg                                m_axi_memory_bus_WVALID_nxt;
  reg                                m_axi_memory_bus_WLAST_reg;
  reg                                m_axi_memory_bus_WLAST_nxt;

  //write response
  reg                                m_axi_memory_bus_BREADY_reg;
  reg                                m_axi_memory_bus_BREADY_nxt;
  
  //Instruction fetch control/////////////////////////////////////////////////
  reg                                store_instruction_fifo_rd_en;
  
  //Write back control///////////////////////////////////////////////////////
  reg                                write_back_req_reg;
  reg                                o_write_back_req_nxt;
  
  //Store Control Signals///////////////////////////////////////////////////
  reg                               activation_out_fifo_rd_en_reg;
  reg                               activation_out_fifo_rd_en_nxt;
  //reg                               store_data_reg_wr_en_reg;
  reg                               store_data_reg_wr_en;
  /////////////////////////////////////////////////////////////////////////

  reg [9:0]                         counter_ptr_reg;
  reg [9:0]                         counter_ptr_nxt;
  reg [2:0]                         ddr_inc_inst_reg;
  reg [2:0]                         ddr_inc_inst_nxt;


  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin

      state_reg <= IDLE;
      //AXI MASTER//////////////////////////////////////////////////////
      //Write Channels
      //write address
      m_axi_memory_bus_AWVALID_reg <= 'd0;
      m_axi_memory_bus_AWADDR_reg <= 'd0;
      m_axi_memory_bus_AWLEN_reg <= 'd0;

      //write data
      m_axi_memory_bus_WVALID_reg <= 'd0;
      m_axi_memory_bus_WLAST_reg <= 1'b1;

      //write response
      m_axi_memory_bus_BREADY_reg <= 'd0;

      //Write back control///////////////////////////////////////////////////////
      write_back_req_reg <= 'd0;

      //Store Control Signals///////////////////////////////////////////////////
      activation_out_fifo_rd_en_reg <= 'd0;
      //store_data_reg_wr_en_reg <= 'd0;
      /////////////////////////////////////////////////////////////////////////
      counter_ptr_reg <= 'd0;
      ddr_inc_inst_reg <= 'd0;
    end
    else
    begin
      state_reg <= state_nxt;
      //AXI MASTER//////////////////////////////////////////////////////
      //Write Channels
      //write address
      m_axi_memory_bus_AWVALID_reg <= m_axi_memory_bus_AWVALID_nxt;
      m_axi_memory_bus_AWADDR_reg <= m_axi_memory_bus_AWADDR_nxt;
      m_axi_memory_bus_AWLEN_reg <= m_axi_memory_bus_AWLEN_nxt;

      //write data
      m_axi_memory_bus_WVALID_reg <= m_axi_memory_bus_WVALID_nxt;
      m_axi_memory_bus_WLAST_reg <= m_axi_memory_bus_WLAST_nxt;

      //write response
      m_axi_memory_bus_BREADY_reg <= m_axi_memory_bus_BREADY_nxt;

      //Write back control///////////////////////////////////////////////////////
      write_back_req_reg <= o_write_back_req_nxt;

      //Store Control Signals///////////////////////////////////////////////////
      activation_out_fifo_rd_en_reg <= activation_out_fifo_rd_en_nxt;
      //store_data_reg_wr_en_reg <= store_data_reg_wr_en_nxt;
      /////////////////////////////////////////////////////////////////////////
      counter_ptr_reg <= counter_ptr_nxt;
      ddr_inc_inst_reg <= ddr_inc_inst_nxt;
      ////////////////////////////////////////////////////////////////////////
    end
  end  

  always @(*) 
  begin
    state_nxt = state_reg;
    //AXI MASTER//////////////////////////////////////////////////////
    //Write Channels
    //write address
    m_axi_memory_bus_AWVALID_nxt = m_axi_memory_bus_AWVALID_reg;
    m_axi_memory_bus_AWADDR_nxt = m_axi_memory_bus_AWADDR_reg;
    m_axi_memory_bus_AWLEN_nxt = m_axi_memory_bus_AWLEN_reg;

    //write data
    m_axi_memory_bus_WVALID_nxt = m_axi_memory_bus_WVALID_reg;
    m_axi_memory_bus_WLAST_nxt = m_axi_memory_bus_WLAST_reg;

    //write response
    m_axi_memory_bus_BREADY_nxt = m_axi_memory_bus_BREADY_reg;
    //Instruction fetch control////////////////////////////////////////////////
    store_instruction_fifo_rd_en = 1'b0;

    //Write back control///////////////////////////////////////////////////////
    o_write_back_req_nxt = write_back_req_reg;

    //Store Control Signals////////////////////////////////////////////////////
    activation_out_fifo_rd_en_nxt = 1'b0;
    store_data_reg_wr_en = 1'b0;
    //store_data_reg_wr_en_nxt = store_data_reg_wr_en_reg;
    //////////////////////////////////////////////////////////////////////////
    counter_ptr_nxt = counter_ptr_reg;
    ddr_inc_inst_nxt = ddr_inc_inst_reg;
    //////////////////////////////////////////////////////////////////////////

    case(state_reg)
      IDLE:
      begin
        if(!i_store_instruction_fifo_empty)
        begin
          if(i_store_instruction_data[31:29] == 3'b100)
          begin
            state_nxt = BUSYWB;
            o_write_back_req_nxt = 1'b1;
            store_instruction_fifo_rd_en = 1'b1;
            
          end
          if(i_store_instruction_data[31:29] == 3'b101)
          begin
            state_nxt = BUSYSTOR;
            store_instruction_fifo_rd_en = 1'b1;
            activation_out_fifo_rd_en_nxt = 1'b1;
            
            //store instruction fetch
            m_axi_memory_bus_AWADDR_nxt = i_store_instruction_data[25:0];
            m_axi_memory_bus_AWLEN_nxt = i_store_instruction_data[28:26];
            m_axi_memory_bus_AWVALID_nxt = 1'b1;
          end
        end
      end

      BUSYWB:
      begin
        if(i_write_back_finish)
        begin
          state_nxt = IDLE;
          o_write_back_req_nxt = 1'b0;
        end
      end

      BUSYSTOR:
      begin
        if(m_axi_memory_bus_AWREADY)
        begin
          m_axi_memory_bus_AWVALID_nxt = 1'b0;
          state_nxt = WAIT;
        end
      end

      WAIT:
      begin
        state_nxt = WAIT2;
      end

      WAIT2:
      begin
        store_data_reg_wr_en = 1'b1;
        m_axi_memory_bus_WVALID_nxt = 1'b1;
        m_axi_memory_bus_WLAST_nxt = 1'b0;
        m_axi_memory_bus_BREADY_nxt = 1'b1;
        state_nxt = BURSTWRITE;
      end

      BURSTWRITE:
      begin
        if(m_axi_memory_bus_WREADY)
        begin
          store_data_reg_wr_en = 1'b1;
          counter_ptr_nxt = counter_ptr_reg + 1;
          if((counter_ptr_reg[4:0] == 5'b11100) &
             (counter_ptr_reg[7:5] != m_axi_memory_bus_AWLEN_nxt))
          begin
            activation_out_fifo_rd_en_nxt = 1'b1;
          end
          if(counter_ptr_reg == {m_axi_memory_bus_AWLEN_nxt, 5'b11110})
          begin
            m_axi_memory_bus_WLAST_nxt = 1'b1;
            state_nxt = BURSTLAST;
          end
        end
      end

      BURSTLAST:
      begin
        state_nxt = BURSTRESP;
        counter_ptr_nxt = 'd0;
        //m_axi_memory_bus_WLAST_nxt = 1'b0;
        m_axi_memory_bus_WVALID_nxt = 1'b0;
      end

      BURSTRESP:
      begin
        if(m_axi_memory_bus_BVALID)
        begin
          if(m_axi_memory_bus_BRESP[1])
          begin
            //error
            state_nxt = BUSYSTOR;
            m_axi_memory_bus_AWVALID_nxt = 1'b1;
          end
          else
          begin
            //complete
            state_nxt = IDLE;
            m_axi_memory_bus_BREADY_nxt = 1'b0;
          end
        end
      end
    endcase
  end

  //AXI MASTER//////////////////////////////////////////////////////
  //Write Channels
  //write address
  assign m_axi_memory_bus_AWVALID = m_axi_memory_bus_AWVALID_reg;
  assign m_axi_memory_bus_AWADDR = {ACTIVATION_WR_BASE_ADDR, m_axi_memory_bus_AWADDR_reg, 2'b00};

  assign m_axi_memory_bus_AWID = 4'b0001;
  assign m_axi_memory_bus_AWLEN = {m_axi_memory_bus_AWLEN_reg, 5'b11111};
  assign m_axi_memory_bus_AWSIZE = 3'b010;
  assign m_axi_memory_bus_AWBURST = 2'b01;

  assign m_axi_memory_bus_AWLOCK = 2'b00;
  assign m_axi_memory_bus_AWCACHE = 'b0;
  assign m_axi_memory_bus_AWPROT = 'b0;
  assign m_axi_memory_bus_AWQOS = 'b0;
  //assign m_axi_memory_bus_AWREGION = 'b0;
  assign m_axi_memory_bus_AWUSER = 4'b0000;

  //write data
  assign m_axi_memory_bus_WVALID = m_axi_memory_bus_WVALID_reg;
  assign m_axi_memory_bus_WSTRB = 'b0;
  assign m_axi_memory_bus_WLAST = m_axi_memory_bus_WLAST_reg;

  //assign m_axi_memory_bus_WID = 4'b0001;
  assign m_axi_memory_bus_WUSER = 4'b0000;

  //write response
  assign m_axi_memory_bus_BREADY = m_axi_memory_bus_BREADY_reg;

  //Write back control///////////////////////////////////////////////////////
  assign o_write_back_req = write_back_req_reg;

  assign o_store_instruction_fifo_rd_en = store_instruction_fifo_rd_en;

  //Store Control Signals///////////////////////////////////////////////////
  assign o_activation_out_fifo_rd_en = activation_out_fifo_rd_en_reg;
  assign o_store_data_reg_wr_en = store_data_reg_wr_en;
  assign o_sel_store_data = counter_ptr_nxt[4:0];
  /////////////////////////////////////////////////////////////////////////

  assign o_store_idle = state_reg[0];
  
endmodule
