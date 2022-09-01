`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/25 01:27:43
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit
#(
  parameter                              QUNATIZED_MANTISSA_WIDTH = 7,
  parameter                              EXPONENT_WIDTH = 8,

  parameter                              ACTIVATION_RD_BASE_ADDR = 4'h8, //8
  parameter                              WEIGHT_RD_BASE_ADDR = 4'h8,//8
  parameter                              ACTIVATION_WR_BASE_ADDR = 4'h8,

  parameter                              AXI_WIDTH_USER =1,              // Master ID
  parameter                              AXI_WIDTH_ID   =4,              // ID width in bits
  parameter                              AXI_WIDTH_AD   =32,             // address width
  parameter                              AXI_WIDTH_DA   =32,             // data width
  parameter                              AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter                              AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter                              AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter                              AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  
  //Excute
  parameter                              MAC_ACC_WIDTH = 48,
  parameter                              BUFFER_ADDR_WIDTH = 15,
  
  parameter                              ACCUM_DATA_WIDTH = 32,
  parameter                              ACCUM_ADDR_WIDTH = 8
  
  //Activation
  
  //Store
)
(
  input  wire                            clk, 
  input  wire                            rst_n,
  // AXI MASTER ACTIVATION=================================================
  //Write Channels
  //write address
  output wire                            m_axi_memory_bus_AWVALID,
  input  wire                            m_axi_memory_bus_AWREADY,
  output wire [AXI_WIDTH_AD-1:0]         m_axi_memory_bus_AWADDR,
  output wire [AXI_WIDTH_ID-1:0]         m_axi_memory_bus_AWID,
  output wire [7:0]                      m_axi_memory_bus_AWLEN,
  output wire [2:0]                      m_axi_memory_bus_AWSIZE,
  output wire [1:0]                      m_axi_memory_bus_AWBURST,
  output wire [1:0]                      m_axi_memory_bus_AWLOCK,
  output wire [3:0]                      m_axi_memory_bus_AWCACHE,
  output wire [2:0]                      m_axi_memory_bus_AWPROT,
  output wire [3:0]                      m_axi_memory_bus_AWQOS,
  //output wire [3:0]                      m_axi_memory_bus_AWREGION,
  output wire [3:0]                      m_axi_memory_bus_AWUSER,

  //write data
  output wire                            m_axi_memory_bus_WVALID,
  input  wire                            m_axi_memory_bus_WREADY,
  output wire [AXI_WIDTH_DS-1:0]         m_axi_memory_bus_WSTRB,
  output wire                            m_axi_memory_bus_WLAST,
  //output wire [AXI_WIDTH_ID-1:0]         m_axi_memory_bus_WID,
  output wire [3:0]                      m_axi_memory_bus_WUSER,

  //write response
  input  wire                            m_axi_memory_bus_BVALID,
  output wire                            m_axi_memory_bus_BREADY,
  input  wire [1:0]                      m_axi_memory_bus_BRESP,
  input  wire [AXI_WIDTH_ID-1:0]         m_axi_memory_bus_BID,
  input  wire                            m_axi_memory_bus_BUSER,

  //Read Channels
  //read address
  output wire                            m_axi_memory_bus_ARVALID,
  input  wire                            m_axi_memory_bus_ARREADY,
  output wire [AXI_WIDTH_AD-1:0]         m_axi_memory_bus_ARADDR,
  output wire [AXI_WIDTH_ID-1:0]         m_axi_memory_bus_ARID,
  output wire [7:0]                      m_axi_memory_bus_ARLEN,
  output wire [2:0]                      m_axi_memory_bus_ARSIZE,
  output wire [1:0]                      m_axi_memory_bus_ARBURST,
  output wire [1:0]                      m_axi_memory_bus_ARLOCK,
  output wire [3:0]                      m_axi_memory_bus_ARCACHE,
  output wire [2:0]                      m_axi_memory_bus_ARPROT,
  output wire [3:0]                      m_axi_memory_bus_ARQOS,
  //output wire [3:0]                      m_axi_memory_bus_ARREGION,
  output wire [3:0]                      m_axi_memory_bus_ARUSER,

  //read data
  input  wire                            m_axi_memory_bus_RVALID,
  output wire                            m_axi_memory_bus_RREADY,
  input  wire                            m_axi_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]         m_axi_memory_bus_RID,
  input  wire [3:0]                      m_axi_memory_bus_RUSER,
  input  wire [1:0]                      m_axi_memory_bus_RRESP,
  
  //AXI MASTER WEIGHT============================================================
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

  //read data
  input  wire                         m_axi_weight_memory_bus_RVALID,
  output wire                         m_axi_weight_memory_bus_RREADY,
  input  wire                         m_axi_weight_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_weight_memory_bus_RID,
  input  wire [3:0]                   m_axi_weight_memory_bus_RUSER,
  input  wire [1:0]                   m_axi_weight_memory_bus_RRESP,
  //============================================================================

  // AXI LITE SLAVE============================================================
  input  wire                            s_axi_axilite_AWVALID,
  output wire                            s_axi_axilite_AWREADY,
  input  wire [AXI_LITE_WIDTH_AD-1:0]    s_axi_axilite_AWADDR,
  input  wire                            s_axi_axilite_WVALID,
  output wire                            s_axi_axilite_WREADY,
  input  wire [AXI_LITE_WIDTH_DA-1:0]    s_axi_axilite_WDATA,
  input  wire [AXI_LITE_WIDTH_DS-1:0]    s_axi_axilite_WSTRB,
  input  wire                            s_axi_axilite_ARVALID,
  output wire                            s_axi_axilite_ARREADY,
  input  wire [AXI_LITE_WIDTH_AD-1:0]    s_axi_axilite_ARADDR,
  output wire                            s_axi_axilite_RVALID,
  input  wire                            s_axi_axilite_RREADY,
  output wire [AXI_LITE_WIDTH_DA-1:0]    s_axi_axilite_RDATA,
  output wire [1:0]                      s_axi_axilite_RRESP,
  output wire                            s_axi_axilite_BVALID,
  input  wire                            s_axi_axilite_BREADY,
  output wire [1:0]                      s_axi_axilite_BRESP,

  //Interrupt==================================================================
  //output wire                            interrupt,
  //===========================================================================

  //Datapath Control Signals==================================================
  //Load Contorl Signals=======================================================
  //activation weight buffer control
  output wire                            o_buffer_wr_en, //buffer write enable
  output wire [BUFFER_ADDR_WIDTH-1:0]    o_buffer_wr_addr, //buffer write 
  //==================
  //load control
  output wire                            o_load_data_reg_wr_en,
  output wire [2:0]                      o_sel_load_data,//axi master read data path control
  //===================
  //write back control
  output wire                            o_sel_wb,
  //===================
  //===========================================================================

  /////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals///////////////////////////////////////////////
  //
  output wire                            o_prepare_weight,
  output wire                            o_load_weight_data_reg_wr_en,
  output wire [4:0]                      o_sel_load_weight_data,  
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  // Excute Control Signals////////////////////////////////////////////////////
  //
  //activation buffer control
  output wire                            o_activation_rd_en, //activation buffer read enable
  output wire [BUFFER_ADDR_WIDTH-1:0]    o_buffer_rd_addr, //buffer address
  //======================
  //systolic array control
  output wire                            o_set_weight, //set prepared weight
  //output wire                            o_weight_data_fifo_wr_en,
  //===================
  //accumulator control
  output wire                            o_bias_mode,
  output wire                            o_set_bias,
  output wire                            o_bias_data_fifo_wr_en,
  output wire                            o_accum_rd_en, 
  output wire                            o_accum_wr_en,
  output wire [ACCUM_ADDR_WIDTH-1:0]     o_accum_addr, 
  //=======================
  //accumulator fifo control
  input  wire                            i_execute_out_fifo_full, //final data
  output wire                            o_execute_out_fifo_wr_en, //final data
  //===========================================================================

  //Activation Control Signals=================================================
  //alu control 
  output wire [3:0]                      vetor_unit_op,
  output wire                            o_set_param,
  output wire                            o_param_data_fifo_wr_en,
  //==========================
  //execute final fifo control
  input  wire                            i_execute_out_fifo_empty, 
  output wire                            o_execute_out_fifo_rd_en,
  //=============================
  //activation accum fifo control
  input  wire                            i_activation_accum_fifo_empty, 
  input  wire                            i_activation_accum_fifo_full,
  output wire                            o_activation_accum_fifo_rd_en, 
  output wire                            o_activation_accum_fifo_wr_en,
  //=============================
  //activation final fifo control
  input  wire                            i_activation_out_fifo_full,
  output wire                            o_activation_out_fifo_wr_en,
  //==========================================================================
    
  //Store Control Signals=====================================================
  input  wire                            i_activation_out_fifo_empty,
  output wire                            o_activation_out_fifo_rd_en,
  output wire                            o_store_data_reg_wr_en,
  output wire [4:0]                      o_sel_store_data
  //==========================================================================
);
  //==========================================================================
  //Instruction Schedular Control Signals
  wire                                   load_instruction_fifo_wr_en;
  wire                                   load_instruction_fifo_rd_en;
  wire                                   load_weight_instruction_fifo_wr_en;
  wire                                   load_weight_instruction_fifo_rd_en;
  wire                                   execute_instruction_fifo_wr_en;
  wire                                   excute_instruction_fifo_rd_en;
  wire                                   activation_instruction_fifo_wr_en;
  wire                                   activation_instruction_fifo_rd_en;
  wire                                   store_instruction_fifo_wr_en;
  wire                                   store_instruction_fifo_rd_en;

  wire                                   load_instruction_fifo_empty;
  wire                                   load_fifo_instruction_full;
  wire                                   load_weight_instruction_fifo_empty;
  wire                                   load_weight_fifo_instruction_full;
  wire                                   execute_instruction_fifo_empty;    
  wire                                   execute_fifo_instruction_full;
  wire                                   activation_instruction_fifo_empty;
  wire                                   activation_instruction_fifo_full;
  wire                                   store_instruction_fifo_empty;
  wire                                   store_instruction_fifo_full;
  
  wire [31:0]                            instruction_data;
  wire [31:0]                            load_instruction_data;
  wire [31:0]                            load_weight_instruction_data;
  wire [31:0]                            execute_instruction_data;
  wire [31:0]                            activation_instruction_data;
  wire [31:0]                            store_instruction_data;
  //=========================================================================
  
  wire                                   write_back_req;
  wire                                   write_back_finish;

  wire                                   sel_wb;
  wire                                   wb_activation_out_fifo_rd_en;
  wire                                   store_activation_out_fifo_rd_en;

  wire                                   load_activation_idle;
  wire                                   load_weight_idle;
  wire                                   execute_idle;
  wire                                   activation_idle;
  wire                                   store_idle;

  wire                                   set_weight;
  assign o_set_weight = set_weight;

  s_axi_lite
  #(
  )
  s_axi_lite
  (
    .clk(clk),
    .rst_n(rst_n),
    //=====================================================================
    // AXI LITE SLAVE
    .S_AXI_AWVALID(s_axi_axilite_AWVALID),
    .S_AXI_AWREADY(s_axi_axilite_AWREADY),
    .S_AXI_AWADDR(s_axi_axilite_AWADDR),
    .S_AXI_WVALID(s_axi_axilite_WVALID),
    .S_AXI_WREADY(s_axi_axilite_WREADY),
    .S_AXI_WDATA(s_axi_axilite_WDATA),
    .S_AXI_WSTRB(s_axi_axilite_WSTRB),
    .S_AXI_ARVALID(s_axi_axilite_ARVALID),
    .S_AXI_ARREADY(s_axi_axilite_ARREADY),
    .S_AXI_ARADDR(s_axi_axilite_ARADDR),
    .S_AXI_RVALID(s_axi_axilite_RVALID),
    .S_AXI_RREADY(s_axi_axilite_RREADY),
    .S_AXI_RDATA(s_axi_axilite_RDATA),
    .S_AXI_RRESP(s_axi_axilite_RRESP),
    .S_AXI_BVALID(s_axi_axilite_BVALID),
    .S_AXI_BREADY(s_axi_axilite_BREADY),
    .S_AXI_BRESP(s_axi_axilite_BRESP),
    
    //===================================================================
    //instruction schedular
    .o_instruction_fifo_empty(load_instruction_fifo_empty),
    .i_instruction_fifo_rd_en(load_instruction_fifo_rd_en),
    .o_instruction_data(load_instruction_data),

    .i_load_activation_status(load_activation_idle),
    .i_load_weight_status({load_weight_idle, load_weight_instruction_fifo_empty}),
    .i_execute_status({{execute_idle, execute_instruction_fifo_empty}}),
    .i_activation_status({activation_idle, activation_instruction_fifo_empty}),
    .i_store_status({store_idle, store_instruction_fifo_empty})
  );

  load_control
  #(
    .ACTIVATION_RD_BASE_ADDR(ACTIVATION_RD_BASE_ADDR)
  )
  load_control
  (
    .clk(clk),
    .rst_n(rst_n),

    //AXI Master Read====================================================
    //Read Channels
    //read address
    .m_axi_memory_bus_ARVALID(m_axi_memory_bus_ARVALID),
    .m_axi_memory_bus_ARREADY(m_axi_memory_bus_ARREADY),
    .m_axi_memory_bus_ARADDR(m_axi_memory_bus_ARADDR),
    .m_axi_memory_bus_ARID(m_axi_memory_bus_ARID),
    .m_axi_memory_bus_ARLEN(m_axi_memory_bus_ARLEN),
    .m_axi_memory_bus_ARSIZE(m_axi_memory_bus_ARSIZE),
    .m_axi_memory_bus_ARBURST(m_axi_memory_bus_ARBURST),
    .m_axi_memory_bus_ARLOCK(m_axi_memory_bus_ARLOCK),
    .m_axi_memory_bus_ARCACHE(m_axi_memory_bus_ARCACHE),
    .m_axi_memory_bus_ARPROT(m_axi_memory_bus_ARPROT),
    .m_axi_memory_bus_ARQOS(m_axi_memory_bus_ARQOS),
    //.m_axi_memory_bus_ARREGION(m_axi_memory_bus_ARREGION),
    .m_axi_memory_bus_ARUSER(m_axi_memory_bus_ARUSER),
    //=========
    //read data
    .m_axi_memory_bus_RVALID(m_axi_memory_bus_RVALID),
    .m_axi_memory_bus_RREADY(m_axi_memory_bus_RREADY),
    .m_axi_memory_bus_RLAST(m_axi_memory_bus_RLAST),
    .m_axi_memory_bus_RID(m_axi_memory_bus_RID),
    .m_axi_memory_bus_RUSER(m_axi_memory_bus_RUSER),
    .m_axi_memory_bus_RRESP(m_axi_memory_bus_RRESP),
    //===================================================================
    //instruction schedular
    .i_load_instruction_fifo_empty(load_instruction_fifo_empty),
    .i_execute_instruction_fifo_full(load_weight_instruction_fifo_full),
    .i_load_instruction_data(load_instruction_data),
    
    .o_load_instruction_fifo_rd_en(load_instruction_fifo_rd_en),
    .o_execute_instruction_fifo_wr_en(load_weight_instruction_fifo_wr_en),

    .o_load_activation_idle(load_activation_idle),
    //============================================================================
    //activation buffer control
    .o_buffer_wr_en(o_buffer_wr_en),
    .o_buffer_wr_addr(o_buffer_wr_addr),
    //Load Contorl Signals=======================================================
    //load control
    .o_load_data_reg_wr_en(o_load_data_reg_wr_en),
    .o_sel_load_data(o_sel_load_data),//axi master read data path control
    //===================
    //write back control
    .o_sel_wb(sel_wb),
    .o_write_back_finish(write_back_finish),
    .o_activation_out_fifo_rd_en(wb_activation_out_fifo_rd_en),
    .i_write_back_req(write_back_req)
    //===========================================================================
  );

  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32),
    .REG_OUT("no")
  ) 
  load_weight_fifo
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(load_weight_instruction_fifo_rd_en), 
    .wr_en(load_weight_instruction_fifo_wr_en),
    .data_in(load_instruction_data),
    .fifo_empty(load_weight_instruction_fifo_empty), 
    .fifo_full(load_weight_instruction_fifo_full),
    .data_out(load_weight_instruction_data)
  );
  
  load_weight_control
  #(
    .WEIGHT_RD_BASE_ADDR(WEIGHT_RD_BASE_ADDR)
  )
  load_weight_control
  (
    .clk(clk), 
    .rst_n(rst_n),
    
    /////////////////////////////////////////////////////////////////////////////////
    //AXI MASTER/////////////////////////////////////////////////////////////////////
    //Read Channels
    //read address
    .m_axi_weight_memory_bus_ARVALID(m_axi_weight_memory_bus_ARVALID),
    .m_axi_weight_memory_bus_ARREADY(m_axi_weight_memory_bus_ARREADY),
    .m_axi_weight_memory_bus_ARADDR(m_axi_weight_memory_bus_ARADDR),
    .m_axi_weight_memory_bus_ARID(m_axi_weight_memory_bus_ARID),
    .m_axi_weight_memory_bus_ARLEN(m_axi_weight_memory_bus_ARLEN),
    .m_axi_weight_memory_bus_ARSIZE(m_axi_weight_memory_bus_ARSIZE),
    .m_axi_weight_memory_bus_ARBURST(m_axi_weight_memory_bus_ARBURST),
    .m_axi_weight_memory_bus_ARLOCK(m_axi_weight_memory_bus_ARLOCK),
    .m_axi_weight_memory_bus_ARCACHE(m_axi_weight_memory_bus_ARCACHE),
    .m_axi_weight_memory_bus_ARPROT(m_axi_weight_memory_bus_ARPROT),
    .m_axi_weight_memory_bus_ARQOS(m_axi_weight_memory_bus_ARQOS),
    //.m_axi_weight_memory_bus_ARREGION(m_axi_weight_memory_bus_ARREGION),
    .m_axi_weight_memory_bus_ARUSER(m_axi_weight_memory_bus_ARUSER),
    //////////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////////
    //Load Weight Control Signal//////////////////////////////////////////////////////
    //read data
    .m_axi_weight_memory_bus_RVALID(m_axi_weight_memory_bus_RVALID),
    .m_axi_weight_memory_bus_RREADY(m_axi_weight_memory_bus_RREADY),
    .m_axi_weight_memory_bus_RLAST(m_axi_weight_memory_bus_RLAST),
    .m_axi_weight_memory_bus_RID(m_axi_weight_memory_bus_RID),
    .m_axi_weight_memory_bus_RUSER(m_axi_weight_memory_bus_RUSER),
    .m_axi_weight_memory_bus_RRESP(m_axi_weight_memory_bus_RRESP),
    //
    //////////////////////
    //instuction scheduler
    .i_load_weight_instruction_fifo_empty(load_weight_instruction_fifo_empty), 
    .i_load_activation_instruction_fifo_full(execute_instruction_fifo_full),
    .i_load_weight_instruction_data(load_weight_instruction_data),
    
    .o_load_weight_instruction_fifo_rd_en(load_weight_instruction_fifo_rd_en),
    .o_load_activation_instruction_fifo_wr_en(execute_instruction_fifo_wr_en),

    .o_load_weight_idle(load_weight_idle),
    //
    /////////////////////
    //load weight control
    .i_set_weight(set_weight),
    .o_load_weight_data_reg_wr_en(o_load_weight_data_reg_wr_en),
    .o_sel_load_weight_data(o_sel_load_weight_data),
    .o_prepare_weight(o_prepare_weight),
    //.o_weight_data_fifo_wr_en(o_weight_data_fifo_wr_en),
    .o_bias_data_fifo_wr_en(o_bias_data_fifo_wr_en),
    .o_param_data_fifo_wr_en(o_param_data_fifo_wr_en)
    ///////////////////////////////////////////////////////////////////////////////////
  );

  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32),
    .REG_OUT("no")
  ) 
  execute_fifo
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(execute_instruction_fifo_rd_en), 
    .wr_en(execute_instruction_fifo_wr_en),
    .data_in(load_weight_instruction_data),
    .fifo_empty(execute_instruction_fifo_empty), 
    .fifo_full(execute_instruction_fifo_full),
    .data_out(execute_instruction_data)
  );

  execute_control
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH),

    .AXI_WIDTH_USER(AXI_WIDTH_USER), // Master ID
    .AXI_WIDTH_ID(AXI_WIDTH_ID), // ID width in bits
    .AXI_WIDTH_AD(AXI_WIDTH_AD), // address width
    .AXI_WIDTH_DA(AXI_WIDTH_DA), // data width
    .AXI_WIDTH_DS(AXI_WIDTH_DS), // data strobe width
    .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD), // axi lite address width
    .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA), // axi lite data width
    .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS), // data strobe width
    
    //Load
    
    //Excute
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH),
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .ACCUM_ADDR_WIDTH(ACCUM_ADDR_WIDTH)
  )
  execute_control
  (
    .clk(clk),
    .rst_n(rst_n),
    //////////////////////////////////////////////////////////////////////////////////
    //instruction scheduler
    .i_execute_instruction_fifo_empty(execute_instruction_fifo_empty),
    .i_activation_instruction_fifo_full(activation_instruction_fifo_full),
    .i_execute_instruction_data(execute_instruction_data),
    
    .o_execute_instruction_fifo_rd_en(execute_instruction_fifo_rd_en),
    .o_activation_instruction_fifo_wr_en(activation_instruction_fifo_wr_en),

    .o_execute_idle(execute_idle),
    //Excute Control Signals//////////////////////////////////////////////////////////
    //activation buffer control
    .o_activation_rd_en(o_activation_rd_en), //activation buffer read enable
    .o_buffer_rd_addr(o_buffer_rd_addr), //buffer address
    ////////////////////////
    //systolic array control
    .o_set_weight(set_weight), //set prepared weight
    /////////////////////
    //accumulator control
    .o_bias_mode(o_bias_mode),
    .o_set_bias(o_set_bias),
    .o_accum_rd_en(o_accum_rd_en), 
    .o_accum_wr_en(o_accum_wr_en),
    .o_accum_addr(o_accum_addr), 
    //////////////////////////
    //accumulator fifo control
    .i_execute_out_fifo_full(i_execute_out_fifo_full), //final data
    .o_execute_out_fifo_wr_en(o_execute_out_fifo_wr_en) //final data
    //////////////////////////////////////////////////////////////////////////////////
  );

  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32),
    .REG_OUT("no")
  ) 
  activation_fifo
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(activation_instruction_fifo_rd_en), 
    .wr_en(activation_instruction_fifo_wr_en),
    .data_in(execute_instruction_data),
    .fifo_empty(activation_instruction_fifo_empty), 
    .fifo_full(activation_instruction_fifo_full),
    .data_out(activation_instruction_data)
  );

  activation_control
  #(
  
  )
  activation_control(
    .clk(clk),
    .rst_n(rst_n),
    .i_activation_instruction_fifo_empty(activation_instruction_fifo_empty),
    .i_store_instruction_fifo_full(store_instruction_fifo_full),
    
    .i_activation_instruction_data(activation_instruction_data),
    
    .o_activation_instruction_fifo_rd_en(activation_instruction_fifo_rd_en),
    .o_store_instruction_fifo_wr_en(store_instruction_fifo_wr_en),

    .o_activation_idle(activation_idle),
    //////////////////////////////////////////////////////////////////////////////////
    //Activation Control Signals//////////////////////////////////////////////////////
    //alu control 
    .o_vetor_unit_op(vetor_unit_op),
    .o_set_param(o_set_param),
    ////////////////////////////
    //execute final fifo control
    .i_execute_out_fifo_empty(i_execute_out_fifo_empty), 
    .o_execute_out_fifo_rd_en(o_execute_out_fifo_rd_en),
    ///////////////////////////////
    //activation accum fifo control
    .i_activation_accum_fifo_empty(i_activation_accum_fifo_empty), 
    .i_activation_accum_fifo_full(i_activation_accum_fifo_full),
    .o_activation_accum_fifo_rd_en(o_activation_accum_fifo_rd_en), 
    .o_activation_accum_fifo_wr_en(o_activation_accum_fifo_wr_en),
    ///////////////////////////////
    //activation final fifo control
    .i_activation_out_fifo_full(i_activation_out_fifo_full),
    .o_activation_out_fifo_wr_en(o_activation_out_fifo_wr_en)
    //////////////////////////////////////////////////////////////////////////////////
  );
  
  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32),
    .REG_OUT("no")
  ) 
  store_fifo
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(store_instruction_fifo_rd_en), 
    .wr_en(store_instruction_fifo_wr_en),
    .data_in(activation_instruction_data),
    .fifo_empty(store_instruction_fifo_empty), 
    .fifo_full(store_instruction_fifo_full),
    .data_out(store_instruction_data)
  );

  store_control
  #(
    .ACTIVATION_WR_BASE_ADDR(ACTIVATION_WR_BASE_ADDR)
  )
  store_control(
    .clk(clk),
    .rst_n(rst_n),

    //////////////////
    //AXI MASTER WRITE
    //axi master write
    .m_axi_memory_bus_AWVALID(m_axi_memory_bus_AWVALID),
    .m_axi_memory_bus_AWREADY(m_axi_memory_bus_AWREADY),
    .m_axi_memory_bus_AWADDR(m_axi_memory_bus_AWADDR),
    .m_axi_memory_bus_AWID(m_axi_memory_bus_AWID),
    .m_axi_memory_bus_AWLEN(m_axi_memory_bus_AWLEN),
    .m_axi_memory_bus_AWSIZE(m_axi_memory_bus_AWSIZE),
    .m_axi_memory_bus_AWBURST(m_axi_memory_bus_AWBURST),
    .m_axi_memory_bus_AWLOCK(m_axi_memory_bus_AWLOCK),
    .m_axi_memory_bus_AWCACHE(m_axi_memory_bus_AWCACHE),
    .m_axi_memory_bus_AWPROT(m_axi_memory_bus_AWPROT),
    .m_axi_memory_bus_AWQOS(m_axi_memory_bus_AWQOS),
    //.m_axi_memory_bus_AWREGION(m_axi_memory_bus_AWREGION),
    .m_axi_memory_bus_AWUSER(m_axi_memory_bus_AWUSER),

    //write data
    .m_axi_memory_bus_WVALID(m_axi_memory_bus_WVALID),
    .m_axi_memory_bus_WREADY(m_axi_memory_bus_WREADY),
    .m_axi_memory_bus_WSTRB(m_axi_memory_bus_WSTRB),
    .m_axi_memory_bus_WLAST(m_axi_memory_bus_WLAST),
    //.m_axi_memory_bus_WID(m_axi_memory_bus_WID),
    .m_axi_memory_bus_WUSER(m_axi_memory_bus_WUSER),

    //write response
    .m_axi_memory_bus_BVALID(m_axi_memory_bus_BVALID),
    .m_axi_memory_bus_BREADY(m_axi_memory_bus_BREADY),
    .m_axi_memory_bus_BRESP(m_axi_memory_bus_BRESP),
    .m_axi_memory_bus_BID(m_axi_memory_bus_BID),
    .m_axi_memory_bus_BUSER(m_axi_memory_bus_BUSER),

    .i_store_instruction_fifo_empty(store_instruction_fifo_empty),
    
    .i_store_instruction_data(store_instruction_data),
    .o_store_instruction_fifo_rd_en(store_instruction_fifo_rd_en),

    .o_store_idle(store_idle),
    //Store Control Signals////////////////////////////////////////////////////
    //Write back control
    .i_write_back_finish(write_back_finish),
    .o_write_back_req(write_back_req),
    ///////////////////////
    //Store Control Signals
    .i_activation_out_fifo_empty(i_activation_out_fifo_empty),
    .o_activation_out_fifo_rd_en(store_activation_out_fifo_rd_en),
    .o_store_data_reg_wr_en(o_store_data_reg_wr_en),
    .o_sel_store_data(o_sel_store_data)
    ///////////////////////////////////////////////////////////////////////////
  );
  assign o_activation_out_fifo_rd_en = sel_wb
                                      ? wb_activation_out_fifo_rd_en
                                      : store_activation_out_fifo_rd_en;
  assign o_sel_wb = sel_wb;
  
endmodule
