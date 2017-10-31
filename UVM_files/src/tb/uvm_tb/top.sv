`timescale 1ns / 100ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "mesi_files.svh"
module top;
   
parameter
  CBUS_CMD_WIDTH           = 3,
  ADDR_WIDTH               = 32,
  DATA_WIDTH               = 32,
  BROAD_TYPE_WIDTH         = 2,  
  BROAD_ID_WIDTH           = 5,  
  BROAD_REQ_FIFO_SIZE      = 4,
  BROAD_REQ_FIFO_SIZE_LOG2 = 2,
  MBUS_CMD_WIDTH           = 3,
  BREQ_FIFO_SIZE           = 2,
  BREQ_FIFO_SIZE_LOG2      = 1;
   
/// Regs and wires
//================================
// System
reg                   clk = 1'b0;          // System clock
reg                   rst = 1'b0;          // Active high system reset

initial
begin
	rst = 1'b1;
	#50
	rst = 1'b0;
end
 
// clock and reset
//================================
always
begin
  #50 clk = !clk;
end

   
// Dumpfile
//================================
initial
begin
  $dumpfile("./dump.vcd");
  $dumpvars(0,top);
end
   


//************************************************
//----------------- Instantiations----------------
//************************************************
mesi_master_if mesi_if_master0();
mesi_master_if mesi_if_master1();
mesi_master_if mesi_if_master2();
mesi_master_if mesi_if_master3();

wire [ADDR_WIDTH-1:0] cbus_addr;
// mesi_isc
mesi_isc #(CBUS_CMD_WIDTH,
           ADDR_WIDTH,
           BROAD_TYPE_WIDTH,
           BROAD_ID_WIDTH,
           BROAD_REQ_FIFO_SIZE,
           BROAD_REQ_FIFO_SIZE_LOG2,
           MBUS_CMD_WIDTH,
           BREQ_FIFO_SIZE,
           BREQ_FIFO_SIZE_LOG2
          )
  mesi_isc_inst
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .mbus_cmd3_i      (mesi_if_master3.mbus_cmd_wire),
     .mbus_cmd2_i      (mesi_if_master2.mbus_cmd_wire),
     .mbus_cmd1_i      (mesi_if_master1.mbus_cmd_wire),
     .mbus_cmd0_i      (mesi_if_master0.mbus_cmd_wire),
     .mbus_addr3_i     (mesi_if_master3.mbus_addr_wire),
     .mbus_addr2_i     (mesi_if_master2.mbus_addr_wire),
     .mbus_addr1_i     (mesi_if_master1.mbus_addr_wire),
     .mbus_addr0_i     (mesi_if_master0.mbus_addr_wire),
     .cbus_ack3_i      (mesi_if_master3.cbus_ack_wire),
     .cbus_ack2_i      (mesi_if_master2.cbus_ack_wire),
     .cbus_ack1_i      (mesi_if_master1.cbus_ack_wire),
     .cbus_ack0_i      (mesi_if_master0.cbus_ack_wire),
     // Outputs
     .cbus_addr_o      (cbus_addr),
     .cbus_cmd3_o      (mesi_if_master3.cbus_cmd),
     .cbus_cmd2_o      (mesi_if_master2.cbus_cmd),
     .cbus_cmd1_o      (mesi_if_master1.cbus_cmd),
     .cbus_cmd0_o      (mesi_if_master0.cbus_cmd),
     .mbus_ack3_o      (mesi_if_master3.mbus_ack),
     .mbus_ack2_o      (mesi_if_master2.mbus_ack),
     .mbus_ack1_o      (mesi_if_master1.mbus_ack),
     .mbus_ack0_o      (mesi_if_master0.mbus_ack)
    );

  assign mesi_if_master3.cbus_addr = cbus_addr;
  assign mesi_if_master2.cbus_addr = cbus_addr;
  assign mesi_if_master1.cbus_addr = cbus_addr;
  assign mesi_if_master0.cbus_addr = cbus_addr;
  assign mesi_if_master3.clk = clk;
  assign mesi_if_master2.clk = clk;
  assign mesi_if_master1.clk = clk;
  assign mesi_if_master0.clk = clk;
  assign mesi_if_master3.rst = rst;
  assign mesi_if_master2.rst = rst;
  assign mesi_if_master1.rst = rst;
  assign mesi_if_master0.rst = rst;

  //assertion module 
  MESI_assertions assertion_module(
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .mbus_cmd3_i      (mesi_if_master3.mbus_cmd_wire),
     .mbus_cmd2_i      (mesi_if_master2.mbus_cmd_wire),
     .mbus_cmd1_i      (mesi_if_master1.mbus_cmd_wire),
     .mbus_cmd0_i      (mesi_if_master0.mbus_cmd_wire),
     .mbus_addr3_i     (mesi_if_master3.mbus_addr_wire),
     .mbus_addr2_i     (mesi_if_master2.mbus_addr_wire),
     .mbus_addr1_i     (mesi_if_master1.mbus_addr_wire),
     .mbus_addr0_i     (mesi_if_master0.mbus_addr_wire),
     .cbus_ack3_i      (mesi_if_master3.cbus_ack_wire),
     .cbus_ack2_i      (mesi_if_master2.cbus_ack_wire),
     .cbus_ack1_i      (mesi_if_master1.cbus_ack_wire),
     .cbus_ack0_i      (mesi_if_master0.cbus_ack_wire),
     // Outputs
     .cbus_addr_o      (cbus_addr),
     .cbus_cmd3_o      (mesi_if_master3.cbus_cmd),
     .cbus_cmd2_o      (mesi_if_master2.cbus_cmd),
     .cbus_cmd1_o      (mesi_if_master1.cbus_cmd),
     .cbus_cmd0_o      (mesi_if_master0.cbus_cmd),
     .mbus_ack3_o      (mesi_if_master3.mbus_ack),
     .mbus_ack2_o      (mesi_if_master2.mbus_ack),
     .mbus_ack1_o      (mesi_if_master1.mbus_ack),
     .mbus_ack0_o      (mesi_if_master0.mbus_ack));


  initial begin
      uvm_config_db #(virtual mesi_master_if)::set(null,"uvm_test_top.master_config_0","mesi_vi_if",mesi_if_master0);
      uvm_config_db #(virtual mesi_master_if)::set(null,"uvm_test_top.master_config_1","mesi_vi_if",mesi_if_master1);
      uvm_config_db #(virtual mesi_master_if)::set(null,"uvm_test_top.master_config_2","mesi_vi_if",mesi_if_master2);
      uvm_config_db #(virtual mesi_master_if)::set(null,"uvm_test_top.master_config_3","mesi_vi_if",mesi_if_master3);
      uvm_top.finish_on_completion=1;
  
      //TODO:Modify the test name here
      run_test();//("single_master_read_write_brdcst_test");
  end


endmodule
