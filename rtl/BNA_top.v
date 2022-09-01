`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/23 17:13:15
// Design Name: 
// Module Name: BNA_top
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


module BNA
#(
  parameter                           QUNATIZED_MANTISSA_WIDTH = 7,
  parameter                           EXPONENT_WIDTH = 8,

  parameter                           ACTIVATION_RD_BASE_ADDR = 4'h8,
  parameter                           WEIGHT_RD_BASE_ADDR = 4'h8,
  parameter                           ACTIVATION_WR_BASE_ADDR = 4'h8,

  parameter                           AXI_WIDTH_USER =1,              // Master ID
  parameter                           AXI_WIDTH_ID   =4,              // ID width in bits
  parameter                           AXI_WIDTH_AD   =32,             // address width
  parameter                           AXI_WIDTH_DA   =32,             // data width
  parameter                           AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter                           AXI_LITE_WIDTH_AD   =4,        // axi lite address width
  parameter                           AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter                           AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  
  //Excute
  parameter                           BIAS_ROM_ADDR = 8,
  parameter                           WEIGHT_RAM_ADDR_WIDTH = 4,
  parameter                           MAC_ACC_WIDTH = 48,
  parameter                           BUFFER_ADDR_WIDTH = 15,
  parameter                           ACCUM_DATA_WIDTH = 32,
  parameter                           ACCUM_ADDR_WIDTH = 10,
  
  //Activation
  parameter                           PARAM_ROM_ADDR_WIDTH = 8
  
  //Store
)
(
  input  wire                         clk,
  input  wire                         resetn,
  
  // AXI MASTER ACTIVATION====================================================
  //Write Channels
  //write address
  output wire                         m_axi_activation_memory_bus_AWVALID,
  input  wire                         m_axi_activation_memory_bus_AWREADY,
  output wire [AXI_WIDTH_AD-1:0]      m_axi_activation_memory_bus_AWADDR,
  output wire [AXI_WIDTH_ID-1:0]      m_axi_activation_memory_bus_AWID,
  output wire [7:0]                   m_axi_activation_memory_bus_AWLEN,
  output wire [2:0]                   m_axi_activation_memory_bus_AWSIZE,
  output wire [1:0]                   m_axi_activation_memory_bus_AWBURST,
  output wire [1:0]                   m_axi_activation_memory_bus_AWLOCK,
  output wire [3:0]                   m_axi_activation_memory_bus_AWCACHE,
  output wire [2:0]                   m_axi_activation_memory_bus_AWPROT,
  output wire [3:0]                   m_axi_activation_memory_bus_AWQOS,
  //output wire [3:0]                   m_axi_activation_memory_bus_AWREGION,
  output wire [3:0]                   m_axi_activation_memory_bus_AWUSER,

  //write data
  output wire                         m_axi_activation_memory_bus_WVALID,
  input  wire                         m_axi_activation_memory_bus_WREADY,
  output wire [AXI_WIDTH_DA-1:0]      m_axi_activation_memory_bus_WDATA,
  output wire [AXI_WIDTH_DS-1:0]      m_axi_activation_memory_bus_WSTRB,
  output wire                         m_axi_activation_memory_bus_WLAST,
  //output wire [AXI_WIDTH_ID-1:0]      m_axi_activation_memory_bus_WID,
  output wire [3:0]                   m_axi_activation_memory_bus_WUSER,

  //write response
  input  wire                         m_axi_activation_memory_bus_BVALID,
  output wire                         m_axi_activation_memory_bus_BREADY,
  input  wire [1:0]                   m_axi_activation_memory_bus_BRESP,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_activation_memory_bus_BID,
  //input  wire                         m_axi_activation_memory_bus_BUSER,

  //Read Channels
  //read address
  output wire                         m_axi_activation_memory_bus_ARVALID,
  input  wire                         m_axi_activation_memory_bus_ARREADY,
  output wire [AXI_WIDTH_AD-1:0]      m_axi_activation_memory_bus_ARADDR,
  output wire [AXI_WIDTH_ID-1:0]      m_axi_activation_memory_bus_ARID,
  output wire [7:0]                   m_axi_activation_memory_bus_ARLEN,
  output wire [2:0]                   m_axi_activation_memory_bus_ARSIZE,
  output wire [1:0]                   m_axi_activation_memory_bus_ARBURST,
  output wire [1:0]                   m_axi_activation_memory_bus_ARLOCK,
  output wire [3:0]                   m_axi_activation_memory_bus_ARCACHE,
  output wire [2:0]                   m_axi_activation_memory_bus_ARPROT,
  output wire [3:0]                   m_axi_activation_memory_bus_ARQOS,
  //output wire [3:0]                   m_axi_activation_memory_bus_ARREGION,
  output wire [3:0]                   m_axi_activation_memory_bus_ARUSER,

  //read data
  input  wire                         m_axi_activation_memory_bus_RVALID,
  output wire                         m_axi_activation_memory_bus_RREADY,
  input  wire [AXI_WIDTH_DA-1:0]      m_axi_activation_memory_bus_RDATA,
  input  wire                         m_axi_activation_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_activation_memory_bus_RID,
  input  wire [3:0]                   m_axi_activation_memory_bus_RUSER,
  input  wire [1:0]                   m_axi_activation_memory_bus_RRESP,
  //=============================================================================

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
  input  wire [AXI_WIDTH_DA-1:0]      m_axi_weight_memory_bus_RDATA,
  input  wire                         m_axi_weight_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_weight_memory_bus_RID,
  input  wire [3:0]                   m_axi_weight_memory_bus_RUSER,
  input  wire [1:0]                   m_axi_weight_memory_bus_RRESP,
  //============================================================================


  // AXI LITE SLAVE
  input  wire                         s_axi_axilite_AWVALID,
  output wire                         s_axi_axilite_AWREADY,
  input  wire [AXI_LITE_WIDTH_AD-1:0] s_axi_axilite_AWADDR,
  input  wire                         s_axi_axilite_WVALID,
  output wire                         s_axi_axilite_WREADY,
  input  wire [AXI_LITE_WIDTH_DA-1:0] s_axi_axilite_WDATA,
  input  wire [AXI_LITE_WIDTH_DS-1:0] s_axi_axilite_WSTRB,
  input  wire                         s_axi_axilite_ARVALID,
  output wire                         s_axi_axilite_ARREADY,
  input  wire [AXI_LITE_WIDTH_AD-1:0] s_axi_axilite_ARADDR,
  output wire                         s_axi_axilite_RVALID,
  input  wire                         s_axi_axilite_RREADY,
  output wire [AXI_LITE_WIDTH_DA-1:0] s_axi_axilite_RDATA,
  output wire [1:0]                   s_axi_axilite_RRESP,
  output wire                         s_axi_axilite_BVALID,
  input  wire                         s_axi_axilite_BREADY,
  output wire [1:0]                   s_axi_axilite_BRESP/*,


  //Interrupt
  output wire                         interrupt*/
);

  /////////////////////////////////////////////////////////////////////////////
  //Datapath Control Signals////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  
  //Load Contorl Signals////////////////////////////////////////////////////////
  //activation weight buffer control
  wire                                  buffer_wr_en; //buffer write enable
  wire [BUFFER_ADDR_WIDTH-1:0]          buffer_wr_addr; //buffer write 
  //////////////
  //load control
  wire                                  load_data_reg_wr_en;
  wire [2:0]                            sel_load_data;//axi master read data path control
  //fifo control
  wire                                  m_axi_rd_fifo_full;
  wire                                  m_axi_rd_fifo_empty;
  wire                                  axi_rd_fifo_rd_en;
  wire                                  axi_rd_fifo_wr_en;
  ////////////////////
  //write back control
  wire                                  sel_wb;
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals////////////////////////////////////////////////
  wire                                  prepare_weight;
  wire                                  load_weight_data_reg_wr_en;
  wire [4:0]                            sel_load_weight_data;
  /////////////////////////////////////////////////////////////////////////////

  //Excute Control Signals/////////////////////////////////////////////////////
  //activation buffer control
  wire                                  activation_rd_en; //activation buffer read enable
  wire [BUFFER_ADDR_WIDTH-1:0]          buffer_rd_addr; //buffer address
  ////////////////////////
  //systolic array control
  wire                                  set_weight; //set prepared weight
  //wire                                  weight_data_fifo_wr_en;
  /////////////////////
  //accumulator control
  wire                                  bias_mode;
  wire                                  set_bias;
  wire                                  bias_data_fifo_wr_en;
  wire                                  accum_rd_en; 
  wire                                  accum_wr_en;
  wire [ACCUM_ADDR_WIDTH-1:0]           accum_addr; 
  //////////////////////////
  //accumulator fifo control
  wire                                  execute_out_fifo_full; //final data
  wire                                  execute_out_fifo_wr_en; //final data
  /////////////////////////////////////////////////////////////////////////////

  //Activation Control Signals/////////////////////////////////////////////////
  //alu control 
  wire [3:0]                            vetor_unit_op;
  wire                                  set_param;
  wire                                  param_data_fifo_wr_en;
  ////////////////////////////
  //execute final fifo control
  wire                                  execute_out_fifo_empty; 
  wire                                  execute_out_fifo_rd_en;
  ///////////////////////////////
  //activation accum fifo control
  wire                                  activation_accum_fifo_empty; 
  wire                                  activation_accum_fifo_full;
  wire                                  activation_accum_fifo_rd_en; 
  wire                                  activation_accum_fifo_wr_en;
  ///////////////////////////////
  //activation final fifo control
  wire                                  activation_out_fifo_full;
  wire                                  activation_out_fifo_wr_en;
  ////////////////////////////////////////////////////////////////////////////
    
  //Store Control Signals/////////////////////////////////////////////////////
  //
  wire                                  activation_out_fifo_empty;
  wire                                  activation_out_fifo_rd_en;
  wire                                  store_data_reg_wr_en;
  wire [4:0]                            sel_store_data;
  ////////////////////////////////////////////////////////////////////////////

  
Datapath
#(
  .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
  .EXPONENT_WIDTH(EXPONENT_WIDTH),

  .AXI_WIDTH_USER(AXI_WIDTH_USER),              // Master ID
  .AXI_WIDTH_ID(AXI_WIDTH_ID),              // ID width in bits
  .AXI_WIDTH_AD(AXI_WIDTH_AD),             // address width
  .AXI_WIDTH_DA(AXI_WIDTH_DA),             // data width
  .AXI_WIDTH_DS(AXI_WIDTH_DS), // data strobe width
  .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD),        // axi lite address width
  .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA),        // axi lite data width
  .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS), // data strobe width
  
  //Load
  
  
  //Excute
  .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
  .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH),
  .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
  .ACCUM_ADDR_WIDTH(ACCUM_ADDR_WIDTH),
  
  //Activation
  .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  
  //Store
  
  
) Datapath
(
  .clk(clk), 
  .rst_n(resetn),

  //Datapath Control Signals=====================================================
  //Load Contorl Signals=========================================================
  //activation weight buffer control
  .i_buffer_wr_en(buffer_wr_en), //buffer write enable
  .i_buffer_wr_addr(buffer_wr_addr), //buffer write 
  //==================
  //load control
  .i_load_data_reg_wr_en(load_data_reg_wr_en),
  .i_sel_load_data(sel_load_data),//axi master read data path control
  //===================
  //write back control
  .i_sel_wb(sel_wb),
  //===========================================================================

  /////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals////////////////////////////////////////////////
  .i_prepare_weight(prepare_weight),
  .i_load_weight_data_reg_wr_en(load_weight_data_reg_wr_en),
  .i_sel_load_weight_data(sel_load_weight_data),  
  /////////////////////////////////////////////////////////////////////////////

  //Excute Control Signals=====================================================
  //activation buffer control
  .i_activation_rd_en(activation_rd_en), //activation buffer read enable
  .i_buffer_rd_addr(buffer_rd_addr), //buffer address
  //======================
  //systolic array control
  .i_set_weight(set_weight), //set prepared weight
  //.i_weight_data_fifo_wr_en(weight_data_fifo_wr_en),
  //===================
  //accumulator control
  .i_bias_mode(bias_mode),
  .i_set_bias(set_bias),
  .i_bias_data_fifo_wr_en(bias_data_fifo_wr_en),
  .i_accum_rd_en(accum_rd_en), 
  .i_accum_wr_en(accum_wr_en),
  .i_accum_addr(accum_addr), 
  //=======================
  //accumulator fifo control
  .o_execute_out_fifo_full(execute_out_fifo_full), //final data
  .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en), //final data
  //===========================================================================

  //Activation Control Signals=================================================
  //alu control 
  .vetor_unit_op(vetor_unit_op),
  .i_set_param(set_param),
  .i_param_data_fifo_wr_en(param_data_fifo_wr_en),
  //==========================
  //execute final fifo control
  .o_execute_out_fifo_empty(execute_out_fifo_empty), 
  .i_execute_out_fifo_rd_en(execute_out_fifo_rd_en),
  //=============================
  //activation accum fifo control
  .o_activation_accum_fifo_empty(activation_accum_fifo_empty), 
  .o_activation_accum_fifo_full(activation_accum_fifo_full),
  .i_activation_accum_fifo_rd_en(activation_accum_fifo_rd_en), 
  .i_activation_accum_fifo_wr_en(activation_accum_fifo_wr_en),
  //=============================
  //activation final fifo control
  .o_activation_out_fifo_full(activation_out_fifo_full),
  .i_activation_out_fifo_wr_en(activation_out_fifo_wr_en),
  //==========================================================================
    
  //Store Control Signals=====================================================
  //Store Control Signals
  .o_activation_out_fifo_empty(activation_out_fifo_empty),
  .i_activation_out_fifo_rd_en(activation_out_fifo_rd_en),
  .i_store_data_reg_wr_en(store_data_reg_wr_en),
  .i_sel_store_data(sel_store_data),
  //==========================================================================




  //==========================================================================
  //============================DATA==========================================
  // AXI MASTER 
  .m_axi_memory_bus_WDATA(m_axi_activation_memory_bus_WDATA),
  .m_axi_memory_bus_RDATA(m_axi_activation_memory_bus_RDATA),
  .m_axi_weight_memory_bus_RDATA(m_axi_weight_memory_bus_RDATA)
);

Control_Unit
#(
  .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
  .EXPONENT_WIDTH(EXPONENT_WIDTH),

  .ACTIVATION_RD_BASE_ADDR(ACTIVATION_RD_BASE_ADDR),
  .WEIGHT_RD_BASE_ADDR(WEIGHT_RD_BASE_ADDR),
  .ACTIVATION_WR_BASE_ADDR(ACTIVATION_WR_BASE_ADDR),

  .AXI_WIDTH_USER(AXI_WIDTH_USER),              // Master ID
  .AXI_WIDTH_ID(AXI_WIDTH_ID),              // ID width in bits
  .AXI_WIDTH_AD(AXI_WIDTH_AD),             // address width
  .AXI_WIDTH_DA(AXI_WIDTH_DA),             // data width
  .AXI_WIDTH_DS(AXI_WIDTH_DS), // data strobe width
  .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD),        // axi lite address width
  .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA),        // axi lite data width
  .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS), // data strobe width
  
  //Load
  
  //Excute
  .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
  .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH),
  .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
  .ACCUM_ADDR_WIDTH(ACCUM_ADDR_WIDTH)  
  //Activation
  
  //Store
) Control_Unit
(
  .clk(clk), 
  .rst_n(resetn),

  // AXI MASTER ACTIVATION====================================================
  //Write Channels
  //write address
  .m_axi_memory_bus_AWVALID(m_axi_activation_memory_bus_AWVALID),
  .m_axi_memory_bus_AWREADY(m_axi_activation_memory_bus_AWREADY),
  .m_axi_memory_bus_AWADDR(m_axi_activation_memory_bus_AWADDR),
  .m_axi_memory_bus_AWID(m_axi_activation_memory_bus_AWID),
  .m_axi_memory_bus_AWLEN(m_axi_activation_memory_bus_AWLEN),
  .m_axi_memory_bus_AWSIZE(m_axi_activation_memory_bus_AWSIZE),
  .m_axi_memory_bus_AWBURST(m_axi_activation_memory_bus_AWBURST),
  .m_axi_memory_bus_AWLOCK(m_axi_activation_memory_bus_AWLOCK),
  .m_axi_memory_bus_AWCACHE(m_axi_activation_memory_bus_AWCACHE),
  .m_axi_memory_bus_AWPROT(m_axi_activation_memory_bus_AWPROT),
  .m_axi_memory_bus_AWQOS(m_axi_activation_memory_bus_AWQOS),
  //.m_axi_memory_bus_AWREGION(m_axi_activation_memory_bus_AWREGION),
  .m_axi_memory_bus_AWUSER(m_axi_activation_memory_bus_AWUSER),

  //write data
  .m_axi_memory_bus_WVALID(m_axi_activation_memory_bus_WVALID),
  .m_axi_memory_bus_WREADY(m_axi_activation_memory_bus_WREADY),
  .m_axi_memory_bus_WSTRB(m_axi_activation_memory_bus_WSTRB),
  .m_axi_memory_bus_WLAST(m_axi_activation_memory_bus_WLAST),
  //.m_axi_memory_bus_WID(m_axi_activation_memory_bus_WID),
  .m_axi_memory_bus_WUSER(m_axi_activation_memory_bus_WUSER),

  //write response
  .m_axi_memory_bus_BVALID(m_axi_activation_memory_bus_BVALID),
  .m_axi_memory_bus_BREADY(m_axi_activation_memory_bus_BREADY),
  .m_axi_memory_bus_BRESP(m_axi_activation_memory_bus_BRESP),
  .m_axi_memory_bus_BID(m_axi_activation_memory_bus_BID),
  .m_axi_memory_bus_BUSER(m_axi_activation_memory_bus_BUSER),

  //Read Channels
  //read address
  .m_axi_memory_bus_ARVALID(m_axi_activation_memory_bus_ARVALID),
  .m_axi_memory_bus_ARREADY(m_axi_activation_memory_bus_ARREADY),
  .m_axi_memory_bus_ARADDR(m_axi_activation_memory_bus_ARADDR),
  .m_axi_memory_bus_ARID(m_axi_activation_memory_bus_ARID),
  .m_axi_memory_bus_ARLEN(m_axi_activation_memory_bus_ARLEN),
  .m_axi_memory_bus_ARSIZE(m_axi_activation_memory_bus_ARSIZE),
  .m_axi_memory_bus_ARBURST(m_axi_activation_memory_bus_ARBURST),
  .m_axi_memory_bus_ARLOCK(m_axi_activation_memory_bus_ARLOCK),
  .m_axi_memory_bus_ARCACHE(m_axi_activation_memory_bus_ARCACHE),
  .m_axi_memory_bus_ARPROT(m_axi_activation_memory_bus_ARPROT),
  .m_axi_memory_bus_ARQOS(m_axi_activation_memory_bus_ARQOS),
  //.m_axi_memory_bus_ARREGION(m_axi_activation_memory_bus_ARREGION),
  .m_axi_memory_bus_ARUSER(m_axi_activation_memory_bus_ARUSER),

  //read data
  .m_axi_memory_bus_RVALID(m_axi_activation_memory_bus_RVALID),
  .m_axi_memory_bus_RREADY(m_axi_activation_memory_bus_RREADY),
  .m_axi_memory_bus_RLAST(m_axi_activation_memory_bus_RLAST),
  .m_axi_memory_bus_RID(m_axi_activation_memory_bus_RID),
  .m_axi_memory_bus_RUSER(m_axi_activation_memory_bus_RUSER),
  .m_axi_memory_bus_RRESP(m_axi_activation_memory_bus_RRESP),
  //============================================================================

  //AXI MASTER WEIGHT===========================================================
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

  //read data
  .m_axi_weight_memory_bus_RVALID(m_axi_weight_memory_bus_RVALID),
  .m_axi_weight_memory_bus_RREADY(m_axi_weight_memory_bus_RREADY),
  .m_axi_weight_memory_bus_RLAST(m_axi_weight_memory_bus_RLAST),
  .m_axi_weight_memory_bus_RID(m_axi_weight_memory_bus_RID),
  .m_axi_weight_memory_bus_RUSER(m_axi_weight_memory_bus_RUSER),
  .m_axi_weight_memory_bus_RRESP(m_axi_weight_memory_bus_RRESP),
  //===========================================================================

  // AXI LITE SLAVE============================================================
  .s_axi_axilite_AWVALID(s_axi_axilite_AWVALID),
  .s_axi_axilite_AWREADY(s_axi_axilite_AWREADY),
  .s_axi_axilite_AWADDR(s_axi_axilite_AWADDR),
  .s_axi_axilite_WVALID(s_axi_axilite_WVALID),
  .s_axi_axilite_WREADY(s_axi_axilite_WREADY),
  .s_axi_axilite_WDATA(s_axi_axilite_WDATA),
  .s_axi_axilite_WSTRB(s_axi_axilite_WSTRB),
  .s_axi_axilite_ARVALID(s_axi_axilite_ARVALID),
  .s_axi_axilite_ARREADY(s_axi_axilite_ARREADY),
  .s_axi_axilite_ARADDR(s_axi_axilite_ARADDR),
  .s_axi_axilite_RVALID(s_axi_axilite_RVALID),
  .s_axi_axilite_RREADY(s_axi_axilite_RREADY),
  .s_axi_axilite_RDATA(s_axi_axilite_RDATA),
  .s_axi_axilite_RRESP(s_axi_axilite_RRESP),
  .s_axi_axilite_BVALID(s_axi_axilite_BVALID),
  .s_axi_axilite_BREADY(s_axi_axilite_BREADY),
  .s_axi_axilite_BRESP(s_axi_axilite_BRESP),

  //Interrupt==================================================================
  //.interrupt(interrupt),
  //===========================================================================
  
  //Datapath Control Signals===================================================
  //Load Contorl Signals=======================================================
  //activation weight buffer control
  .o_buffer_wr_en(buffer_wr_en), //buffer write enable
  .o_buffer_wr_addr(buffer_wr_addr), //buffer write 
  //==================
  //load control
  .o_load_data_reg_wr_en(load_data_reg_wr_en),
  .o_sel_load_data(sel_load_data),//axi master read data path control
  //===================
  //write back control
  .o_sel_wb(sel_wb),
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals////////////////////////////////////////////////
  .o_prepare_weight(prepare_weight),
  .o_load_weight_data_reg_wr_en(load_weight_data_reg_wr_en),
  .o_sel_load_weight_data(sel_load_weight_data),  
  /////////////////////////////////////////////////////////////////////////////

  //Excute Control Signals=====================================================
  //activation buffer control
  .o_activation_rd_en(activation_rd_en), //activation buffer read enable
  .o_buffer_rd_addr(buffer_rd_addr), //buffer address
  //======================
  //systolic array control
  .o_set_weight(set_weight), //set prepared weight
  //.o_weight_data_fifo_wr_en(weight_data_fifo_wr_en),
  //===================
  //accumulator control
  .o_bias_mode(bias_mode),
  .o_set_bias(set_bias),
  .o_bias_data_fifo_wr_en(bias_data_fifo_wr_en),
  .o_accum_rd_en(accum_rd_en), 
  .o_accum_wr_en(accum_wr_en),
  .o_accum_addr(accum_addr), 
  //=======================
  //accumulator fifo control
  .i_execute_out_fifo_full(execute_out_fifo_full), //final data
  .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en), //final data
  //===========================================================================

  //Activation Control Signals=================================================
  //alu control 
  .vetor_unit_op(vetor_unit_op),
  .o_set_param(set_param),
  .o_param_data_fifo_wr_en(param_data_fifo_wr_en),
  //==========================
  //execute final fifo control
  .i_execute_out_fifo_empty(execute_out_fifo_empty), 
  .o_execute_out_fifo_rd_en(execute_out_fifo_rd_en),
  //=============================
  //activation accum fifo control
  .i_activation_accum_fifo_empty(activation_accum_fifo_empty), 
  .i_activation_accum_fifo_full(activation_accum_fifo_full),
  .o_activation_accum_fifo_rd_en(activation_accum_fifo_rd_en), 
  .o_activation_accum_fifo_wr_en(activation_accum_fifo_wr_en),
  //=============================
  //activation final fifo control
  .i_activation_out_fifo_full(activation_out_fifo_full),
  .o_activation_out_fifo_wr_en(activation_out_fifo_wr_en),
  //==========================================================================
    
  //Store Control Signals=====================================================
  .i_activation_out_fifo_empty(activation_out_fifo_empty),
  .o_activation_out_fifo_rd_en(activation_out_fifo_rd_en),
  .o_store_data_reg_wr_en(store_data_reg_wr_en),
  .o_sel_store_data(sel_store_data)
  //==========================================================================
);
endmodule