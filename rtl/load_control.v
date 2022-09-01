`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/27 18:42:59
// Design Name: 
// Module Name: load_control
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


module load_control
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8,
  parameter ACTIVATION_RD_BASE_ADDR = 4'h8, //8

  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  //Load
  parameter ACTIVATION_MEM_ID = 1,
  
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
  input wire clk, rst_n,
  
  //AXI MASTER===================================================================
  //Read Channels
  //read address
  output wire                         m_axi_memory_bus_ARVALID,
  input  wire                         m_axi_memory_bus_ARREADY,
  output wire [AXI_WIDTH_AD-1:0]      m_axi_memory_bus_ARADDR,
  output wire [AXI_WIDTH_ID-1:0]      m_axi_memory_bus_ARID,
  output wire [7:0]                   m_axi_memory_bus_ARLEN,
  output wire [2:0]                   m_axi_memory_bus_ARSIZE,
  output wire [1:0]                   m_axi_memory_bus_ARBURST,
  output wire [1:0]                   m_axi_memory_bus_ARLOCK,
  output wire [3:0]                   m_axi_memory_bus_ARCACHE,
  output wire [2:0]                   m_axi_memory_bus_ARPROT,
  output wire [3:0]                   m_axi_memory_bus_ARQOS,
  //output wire [3:0]                   m_axi_memory_bus_ARREGION,
  output wire [3:0]                   m_axi_memory_bus_ARUSER,

  //read data
  input  wire                         m_axi_memory_bus_RVALID,
  output wire                         m_axi_memory_bus_RREADY,
  input  wire                         m_axi_memory_bus_RLAST,
  input  wire [AXI_WIDTH_ID-1:0]      m_axi_memory_bus_RID,
  input  wire [3:0]                   m_axi_memory_bus_RUSER,
  input  wire [1:0]                   m_axi_memory_bus_RRESP,
  //============================================================================
  //instuction scheduler
  input wire                          i_load_instruction_fifo_empty, 
  input wire                          i_execute_instruction_fifo_full,
  input wire [31:0]                   i_load_instruction_data,
  
  output wire                         o_load_instruction_fifo_rd_en,
  output wire                         o_execute_instruction_fifo_wr_en,

  output wire                         o_load_activation_idle,
  //============================================================================
  //activation weight buffer control
  output wire                         o_buffer_wr_en,
  output wire [BUFFER_ADDR_WIDTH-1:0] o_buffer_wr_addr,
  //============================================================================
  //load control
  output wire                         o_load_data_reg_wr_en,
  output wire [2:0]                   o_sel_load_data,//axi master read data path control
  //============================================================================
  //write back control
  output wire                         o_sel_wb,
  output wire                         o_write_back_finish,
  output wire                         o_activation_out_fifo_rd_en,
  input  wire                         i_write_back_req
);

  localparam
    IDLE            = 9'b000000001,
    WAITBFPCONV     = 9'b000000010,
    BUSYWB          = 9'b000000100,
    WAITWBVALID     = 9'b000001000,
    LDFETCH         = 9'b000010000,
    LDBUSY          = 9'b000100000,
    LDBURSTRD       = 9'b001000000,
    LDLAST          = 9'b010000000,
    FETCHOTHER      = 9'b100000000;
    
    
  reg [8:0]                          state_reg;
  reg [8:0]                          state_nxt;
  
  reg [VALID_SIZE-1:0]               valid;
  //AXI MASTER===================================================================
  //Read Channels
  //read address
  reg                                m_axi_memory_bus_ARVALID_reg;
  reg                                m_axi_memory_bus_ARVALID_nxt;
  reg  [AXI_WIDTH_AD-6-1:0]          m_axi_memory_bus_ARADDR_reg;
  reg  [AXI_WIDTH_AD-6-1:0]          m_axi_memory_bus_ARADDR_nxt;
  reg  [AXI_WIDTH_ID-1:0]            m_axi_memory_bus_ARID_reg;
  reg  [AXI_WIDTH_ID-1:0]            m_axi_memory_bus_ARID_nxt;
  reg  [7-3:0]                       m_axi_memory_bus_ARLEN_reg;
  reg  [7-3:0]                       m_axi_memory_bus_ARLEN_nxt;

  //read data
  reg                                m_axi_memory_bus_RREADY_reg;
  reg                                m_axi_memory_bus_RREADY_nxt;
  //============================================================================
  //instuction scheduler
  reg                                load_instruction_fifo_rd_en;
  reg                                execute_instruction_fifo_wr_en;
  //============================================================================
  //activation weight buffer control
  reg                                buffer_wr_en_reg;
  reg                                buffer_wr_en_nxt;
  reg  [BUFFER_ADDR_WIDTH-1:0]       buffer_wr_addr_reg;
  reg  [BUFFER_ADDR_WIDTH-1:0]       buffer_wr_addr_nxt;
  reg  [BUFFER_ADDR_WIDTH-1:0]       buffer_wr_addr_reg_2;
  //============================================================================
  //load control
  reg                                load_data_reg_wr_en;
  reg  [2:0]                         sel_load_data_reg;
  reg  [2:0]                         sel_load_data_nxt;
  //fifo control
  reg                                axi_rd_fifo_rd_en_reg;
  reg                                axi_rd_fifo_rd_en_nxt;
  reg                                axi_rd_fifo_wr_en_reg;
  reg                                axi_rd_fifo_wr_en_nxt;
  //============================================================================
  //write back control
  reg                                sel_wb_reg;
  reg                                sel_wb_nxt;
  reg                                activation_out_fifo_rd_en_reg;
  reg                                activation_out_fifo_rd_en_nxt;
  reg                                write_back_finish_reg;
  reg                                write_back_finish_nxt;
  reg                                wb_busy;
  wire                               wb_valid;
  //============================================================================
  reg [9:0]                          counter_ptr_reg;
  reg [9:0]                          counter_ptr_nxt;

  reg [2:0]                          buffer_inc_inst_nxt;
  reg [2:0]                          buffer_inc_inst_reg;
  //==========================================================================
  
  wire [31:0]                        write_back_temp_instruction_data;
  reg                                write_back_temp_fifo_wr_en;
  reg                                write_back_temp_fifo_rd_en;
  
  fifo_registered_output
  #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32),
    .REG_OUT("no")
  ) 
  tmp_store_fifo
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en(write_back_temp_fifo_rd_en), 
    .wr_en(write_back_temp_fifo_wr_en),
    .data_in(i_load_instruction_data),
    .fifo_empty(), 
    .fifo_full(),
    .data_out(write_back_temp_instruction_data)
  );

  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      state_reg <= IDLE;
      m_axi_memory_bus_ARVALID_reg <= 'd0;
      m_axi_memory_bus_ARADDR_reg <= 'd0;
      m_axi_memory_bus_ARID_reg <= 'd0;
      m_axi_memory_bus_ARLEN_reg <= 'd0;
      m_axi_memory_bus_RREADY_reg <= 'd0;

      buffer_wr_en_reg <= 'd0;
      buffer_wr_addr_reg <= 'd0;
      buffer_wr_addr_reg_2 <= 'd0;
      sel_load_data_reg <= 'd0;
      axi_rd_fifo_rd_en_reg <= 'd0;
      axi_rd_fifo_wr_en_reg <= 'd0;
      sel_wb_reg <= 'd0;
      write_back_finish_reg <= 'd0;
      counter_ptr_reg <= 'd0;
      buffer_inc_inst_reg <= 'd0;
      activation_out_fifo_rd_en_reg <= 'd0;
    end
    else
    begin
      state_reg <= state_nxt;
      m_axi_memory_bus_ARVALID_reg <= m_axi_memory_bus_ARVALID_nxt;
      m_axi_memory_bus_ARADDR_reg <= m_axi_memory_bus_ARADDR_nxt;
      m_axi_memory_bus_ARID_reg <= m_axi_memory_bus_ARID_nxt;
      m_axi_memory_bus_ARLEN_reg <= m_axi_memory_bus_ARLEN_nxt;
      m_axi_memory_bus_RREADY_reg <= m_axi_memory_bus_RREADY_nxt;

      buffer_wr_en_reg <= buffer_wr_en_nxt;
      buffer_wr_addr_reg_2 <= buffer_wr_addr_reg;
      buffer_wr_addr_reg <= buffer_wr_addr_nxt;
      sel_load_data_reg <= sel_load_data_nxt;
      axi_rd_fifo_rd_en_reg <= axi_rd_fifo_rd_en_nxt;
      axi_rd_fifo_wr_en_reg <= axi_rd_fifo_wr_en_nxt;
      sel_wb_reg <= sel_wb_nxt;
      write_back_finish_reg <= write_back_finish_nxt;
      counter_ptr_reg <= counter_ptr_nxt;
      buffer_inc_inst_reg <= buffer_inc_inst_nxt;
      activation_out_fifo_rd_en_reg <= activation_out_fifo_rd_en_nxt;
    end
  end


  always @(*)
  begin
      state_nxt = state_reg;
      //AXI MASTER===================================================================
      //Read Channels
      //read address
      m_axi_memory_bus_ARVALID_nxt = m_axi_memory_bus_ARVALID_reg;
      m_axi_memory_bus_ARADDR_nxt = m_axi_memory_bus_ARADDR_reg;
      m_axi_memory_bus_ARID_nxt = m_axi_memory_bus_ARID_reg;
      m_axi_memory_bus_ARLEN_nxt = m_axi_memory_bus_ARLEN_reg;
    
      //read data
      m_axi_memory_bus_RREADY_nxt = m_axi_memory_bus_RREADY_reg;
      //============================================================================
      //instuction scheduler
      load_instruction_fifo_rd_en = 1'b0;
      execute_instruction_fifo_wr_en = 1'b0;
      //============================================================================
      //activation weight buffer control
      buffer_wr_en_nxt = 1'b0;
      buffer_wr_addr_nxt = buffer_wr_addr_reg;
      //============================================================================
      //load control
      load_data_reg_wr_en = 1'b0;
      sel_load_data_nxt = sel_load_data_reg;
      //fifo control
      axi_rd_fifo_rd_en_nxt = axi_rd_fifo_rd_en_reg;
      axi_rd_fifo_wr_en_nxt = axi_rd_fifo_wr_en_reg;
      //============================================================================
      //write back control
      sel_wb_nxt = sel_wb_reg;
      write_back_finish_nxt = write_back_finish_reg;
      wb_busy = 1'b0;
      //============================================================================      
      counter_ptr_nxt = counter_ptr_reg;
      buffer_inc_inst_nxt = buffer_inc_inst_reg;
      //==========================================================================
      write_back_temp_fifo_rd_en = 1'b0;
      write_back_temp_fifo_wr_en = 1'b0;
      activation_out_fifo_rd_en_nxt = activation_out_fifo_rd_en_reg;
      
    case (state_reg)
      ///////////////////////////////////////////////////////////////////////////////
      //IDLE/////////////////////////////////////////////////////////////////////////
      IDLE:
      begin
        if(i_write_back_req) //write back request
        begin
          //write back
          state_nxt = WAITBFPCONV;
          sel_wb_nxt = 1'b1;
          write_back_temp_fifo_rd_en = 1'b1;
          wb_busy = 1'b1;
          
          //instruction fetch
          buffer_inc_inst_nxt = write_back_temp_instruction_data[2:0];
          counter_ptr_nxt = write_back_temp_instruction_data[10:3];
          buffer_wr_addr_nxt = write_back_temp_instruction_data[28:11];

          //activation_out_fifo_rd_en_nxt = 1'b1;
          //buffer_wr_en_nxt = 1'b1;
        end
        else
        begin
          if(!i_load_instruction_fifo_empty)
          begin
            if(i_load_instruction_data[31:29] == 3'b000)
            begin//load activation
                //load
                state_nxt = LDFETCH;
                //laod activation high instruction fetch
                load_instruction_fifo_rd_en = 1'b1;
                buffer_wr_addr_nxt = i_load_instruction_data[28:11];
                buffer_inc_inst_nxt =  i_load_instruction_data[2:0];
            end
            else
            begin
              if(!i_execute_instruction_fifo_full)
              begin       
                load_instruction_fifo_rd_en = 1'b1;
                execute_instruction_fifo_wr_en = 1'b1;

                if(i_load_instruction_data[31:29] == 3'b010)
                begin //execute instruction fetch (64bit instruction)
                  state_nxt = FETCHOTHER;
                end

                if(i_load_instruction_data[31:29] == 3'b100)
                begin //write back
                  //push write back instruction to fifo
                  write_back_temp_fifo_wr_en = 1'b1;
                end
              end
            end
          end
        end
      end
      //=============================================================================

      //=============================================================================
      //write back===================================================================
      WAITBFPCONV:
      begin
        activation_out_fifo_rd_en_nxt = 1'b1;
        if(wb_valid)
        begin
          state_nxt = BUSYWB;
        end
      end

      BUSYWB:
      begin
        buffer_wr_en_nxt = 1'b1;
        if(counter_ptr_reg == 8'b0)
        begin
          state_nxt = WAITWBVALID;
          
        end
        else
        begin
          buffer_wr_addr_nxt = buffer_wr_addr_reg + 1;
          counter_ptr_nxt = counter_ptr_reg - 1;
          if(counter_ptr_reg == 8'b00000101)
          begin
            activation_out_fifo_rd_en_nxt = 1'b0;           
          end
        end
      end

      WAITWBVALID:
      begin
        write_back_finish_nxt = 1'b1;
        if(!i_write_back_req)
        begin
          state_nxt = IDLE;
          write_back_finish_nxt = 1'b0;
          sel_wb_nxt = 1'b0;
        end
      end
      ///////////////////////////////////////////////////////////////////////////////


      ///////////////////////////////////////////////////////////////////////////////
      //LOAD ACTIVATION//////////////////////////////////////////////////////////////
      LDFETCH:
      begin
        if(!i_load_instruction_fifo_empty)
        begin 
          state_nxt = LDBUSY;
          //low instruction fetch
          load_instruction_fifo_rd_en = 1'b1;
          m_axi_memory_bus_ARVALID_nxt = 1'b1;
          m_axi_memory_bus_ARADDR_nxt = i_load_instruction_data[25:0];
          m_axi_memory_bus_ARLEN_nxt = i_load_instruction_data[30:26];
          sel_wb_nxt = 1'b0;
        end
      end

      LDBUSY: //5
      begin
        if(m_axi_memory_bus_ARREADY)
        begin
          state_nxt = LDBURSTRD;
          m_axi_memory_bus_ARVALID_nxt = 1'b0;
          m_axi_memory_bus_RREADY_nxt = 1'b1;
          sel_load_data_nxt = 3'b0;
        end
      end

      LDBURSTRD: //6
      begin
        if(m_axi_memory_bus_RVALID & //wait rvalid
          (m_axi_memory_bus_RID == ACTIVATION_MEM_ID) & //read id
          (!m_axi_memory_bus_RRESP[1])) //response : ok
        begin
          sel_load_data_nxt = sel_load_data_reg + 1;
          load_data_reg_wr_en = 1'b1;
          if(sel_load_data_reg == 3'b111)
          begin
            buffer_wr_en_nxt = 1'b1; //delayed 1 cycle
            buffer_wr_addr_nxt = buffer_wr_addr_reg + buffer_inc_inst_reg;
            if(m_axi_memory_bus_RLAST) //last data
            begin
              state_nxt = LDLAST;
            end
          end
        end
      end

      LDLAST:
      begin
        m_axi_memory_bus_RREADY_nxt = 1'b0;
        state_nxt = IDLE;
      end
      ///////////////////////////////////////////////////////////////////////////////

      ///////////////////////////////////////////////////////////////////////////////
      //OTHER INSTRUCTION FETCH//////////////////////////////////////////////////////
      FETCHOTHER:
      begin
        if((!i_load_instruction_fifo_empty)&(!i_execute_instruction_fifo_full))
        begin
          state_nxt = IDLE;
          load_instruction_fifo_rd_en = 1'b1;
          execute_instruction_fifo_wr_en = 1'b1;
        end
      end
      /////////////////////////////////////////////////////////////////////////////
    endcase
  end

  variable_length_shift_register
  #(
    .DATA_WIDTH(1),
    .DELAY(8) 
  ) writeback_valid
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data(wb_busy),
    .o_data(wb_valid)
  );

  //AXI MASTER////////////////////////////////////////////////////////////////////
  //Read Channels
  //read address
  assign m_axi_memory_bus_ARVALID = m_axi_memory_bus_ARVALID_reg; 
  assign m_axi_memory_bus_ARADDR = {ACTIVATION_RD_BASE_ADDR, m_axi_memory_bus_ARADDR_reg, 2'b00}; 
  assign m_axi_memory_bus_ARID = ACTIVATION_MEM_ID; //m_axi_memory_bus_ARID_reg; 
  assign m_axi_memory_bus_ARLEN = {m_axi_memory_bus_ARLEN_reg, 3'b111}; //m_axi_memory_bus_ARLEN_reg; 
  assign m_axi_memory_bus_ARSIZE = 3'b010; //m_axi_memory_bus_ARSIZE_reg; 
  assign m_axi_memory_bus_ARBURST = 2'b01; //m_axi_memory_bus_ARBURST_reg; 

  assign m_axi_memory_bus_ARLOCK = 2'b00; //m_axi_memory_bus_ARLOCK_reg; 
  assign m_axi_memory_bus_ARCACHE = 'b0; //m_axi_memory_bus_ARCACHE_reg; 
  assign m_axi_memory_bus_ARPROT = 'b0; //m_axi_memory_bus_ARPROT_reg; 
  assign m_axi_memory_bus_ARQOS = 'b0; //m_axi_memory_bus_ARQOS_reg; 
  //assign m_axi_memory_bus_ARREGION = 'b0; //m_axi_memory_bus_ARREGION_reg; 
  assign m_axi_memory_bus_ARUSER = 4'b0000; //m_axi_memory_bus_ARUSER_reg; 

  //read data
  assign m_axi_memory_bus_RREADY = m_axi_memory_bus_RREADY_reg; 
  //============================================================================
  //instuction scheduler 
  
  assign o_load_instruction_fifo_rd_en = load_instruction_fifo_rd_en;
  assign o_execute_instruction_fifo_wr_en = execute_instruction_fifo_wr_en;
  //============================================================================
  //activation weight buffer control
  assign o_buffer_wr_en = buffer_wr_en_reg;
  assign o_buffer_wr_addr = buffer_wr_addr_reg_2;
  //============================================================================
  //load control
  assign o_load_data_reg_wr_en = load_data_reg_wr_en;
  assign o_sel_load_data = sel_load_data_reg;//axi master read data path control
  //fifo control
  assign o_axi_rd_fifo_rd_en = axi_rd_fifo_rd_en_reg;
  assign o_axi_rd_fifo_wr_en = axi_rd_fifo_wr_en_reg;
  //============================================================================
  //write back control
  assign o_sel_wb = sel_wb_reg;
  assign o_write_back_finish = write_back_finish_reg; 
  //============================================================================
  assign o_activation_out_fifo_rd_en = activation_out_fifo_rd_en_reg;

  assign o_load_activation_idle = state_reg[0];

endmodule
