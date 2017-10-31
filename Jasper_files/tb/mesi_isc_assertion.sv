module MESI_assertions (
     clk,
     rst,
     mbus_cmd3_i,
     mbus_cmd2_i,
     mbus_cmd1_i,
     mbus_cmd0_i,
     mbus_addr3_i,
     mbus_addr2_i,
     mbus_addr1_i,
     mbus_addr0_i,
     cbus_ack3_i,
     cbus_ack2_i,
     cbus_ack1_i,
     cbus_ack0_i,
     cbus_addr_o,
     cbus_cmd3_o,
     cbus_cmd2_o,
     cbus_cmd1_o,
     cbus_cmd0_o,
     mbus_ack3_o,
     mbus_ack2_o,
     mbus_ack1_o,
     mbus_ack0_o,
     fifo_full
		       );

localparam
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


localparam
	MBUS_NOP		= 'd0,
	MBUS_WRITE		= 'd1, 
	MBUS_READ		= 'd2,
	MBUS_WRITE_BROADCAST	= 'd3,
	MBUS_READ_BROADCAST	= 'd4,
	CBUS_NOP		= 'd0,
	CBUS_WRITE_SNOOP	= 'd1,
	CBUS_READ_SNOOP		= 'd2,
	CBUS_ENABLE_WRITE	= 'd3,
	CBUS_ENABLE_READ	= 'd4;
// System
input                   clk;          // System clock
input                   rst;          // Active high system reset
// Main buses
input [MBUS_CMD_WIDTH-1:0] mbus_cmd3_i; // Main bus3 command
input [MBUS_CMD_WIDTH-1:0] mbus_cmd2_i; // Main bus2 command
input [MBUS_CMD_WIDTH-1:0] mbus_cmd1_i; // Main bus1 command
input [MBUS_CMD_WIDTH-1:0] mbus_cmd0_i; // Main bus0 command
// Coherence buses
input [ADDR_WIDTH-1:0]  mbus_addr3_i;  // Coherence bus3 address
input [ADDR_WIDTH-1:0]  mbus_addr2_i;  // Coherence bus2 address
input [ADDR_WIDTH-1:0]  mbus_addr1_i;  // Coherence bus1 address
input [ADDR_WIDTH-1:0]  mbus_addr0_i;  // Coherence bus0 address
input                   cbus_ack3_i;  // Coherence bus3 acknowledge
input                   cbus_ack2_i;  // Coherence bus2 acknowledge
input                   cbus_ack1_i;  // Coherence bus1 acknowledge
input                   cbus_ack0_i;  // Coherence bus0 acknowledge

// Outputs
//================================
input [3:0]		fifo_full;

input [ADDR_WIDTH-1:0] cbus_addr_o;  // Coherence bus address. All busses have
                                      // the same address
input [CBUS_CMD_WIDTH-1:0] cbus_cmd3_o; // Coherence bus3 command
input [CBUS_CMD_WIDTH-1:0] cbus_cmd2_o; // Coherence bus2 command
input [CBUS_CMD_WIDTH-1:0] cbus_cmd1_o; // Coherence bus1 command
input [CBUS_CMD_WIDTH-1:0] cbus_cmd0_o; // Coherence bus0 command

input                  	mbus_ack3_o;  // Main bus3 acknowledge
input                  	mbus_ack2_o;  // Main bus2 acknowledge
input                  	mbus_ack1_o;  // Main bus1 acknowledge
input                  	mbus_ack0_o;  // Main bus0 acknowledge

reg			cbus_ack0_latch;
reg			cbus_ack1_latch;
reg			cbus_ack2_latch;
reg			cbus_ack3_latch;
reg 			read_write_en_ack ;
reg [1:0]		snoop_ack_cnt = 0;
reg 			not_initial;

always @(posedge clk)
begin
	if(rst)
	begin 
		cbus_ack0_latch	<=	1'b0;
		cbus_ack1_latch	<=	1'b0;
		cbus_ack2_latch	<=	1'b0;
		cbus_ack3_latch	<=	1'b0;
		not_initial	<=	1'b0;
	end
	else
 	begin
 		if(not_initial == 1'b0)
 		begin 
 			not_initial	<=	1'b1;
 		end
		if(cbus_ack0_i && (cbus_cmd0_o == CBUS_READ_SNOOP || cbus_cmd0_o == CBUS_WRITE_SNOOP))
 		begin
 			cbus_ack0_latch	<=	1'b1;
		end
		
		if(cbus_ack1_i && (cbus_cmd1_o == CBUS_READ_SNOOP || cbus_cmd1_o == CBUS_WRITE_SNOOP))
 		begin
 			cbus_ack1_latch	<=	1'b1;
		end
		
		if(cbus_ack2_i && (cbus_cmd2_o == CBUS_READ_SNOOP || cbus_cmd2_o == CBUS_WRITE_SNOOP))
 		begin
 			cbus_ack2_latch	<=	1'b1;
		end
		
		if(cbus_ack3_i && (cbus_cmd3_o == CBUS_READ_SNOOP || cbus_cmd3_o == CBUS_WRITE_SNOOP))
 		begin
 			cbus_ack3_latch	<=	1'b1;
		end
	
 		if(cbus_cmd3_o == CBUS_ENABLE_WRITE || cbus_cmd2_o == CBUS_ENABLE_WRITE || cbus_cmd1_o == CBUS_ENABLE_WRITE || cbus_cmd0_o == CBUS_ENABLE_WRITE || cbus_cmd3_o == CBUS_ENABLE_READ || cbus_cmd2_o == CBUS_ENABLE_READ || cbus_cmd1_o == CBUS_ENABLE_READ || cbus_cmd0_o == CBUS_ENABLE_READ)
 		begin	
 			cbus_ack3_latch	<=	1'b0;
 			cbus_ack2_latch	<=	1'b0;
 			cbus_ack1_latch	<=	1'b0;
 			cbus_ack0_latch	<=	1'b0;
 	 	 	$display("cbus_ack_latch reset");
 		end
		
	end
 
end


//*********************************************************************************************
//----------------------------------------Assertions-------------------------------------------
//*********************************************************************************************


//**********************************************************
//-----------All ack immediately followed by Enable---------
//**********************************************************
property CBusAck_imm_REnable(cbus_cmd,cbus_cmd0,cbus_cmd1,cbus_cmd2,cbus_ack_latch_Snoop0,cbus_ack_latch_Snoop1,cbus_ack_latch_Snoop2);
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd0) && (cbus_cmd0== CBUS_READ_SNOOP && cbus_cmd1==CBUS_READ_SNOOP && cbus_cmd2==CBUS_READ_SNOOP)) ##[1:4] (cbus_ack_latch_Snoop0 && cbus_ack_latch_Snoop1 && cbus_ack_latch_Snoop2) |-> (cbus_cmd == CBUS_ENABLE_READ) ;
endproperty

property CBusAck_imm_WEnable(cbus_cmd,cbus_cmd0,cbus_cmd1,cbus_cmd2,cbus_ack_latch_Snoop0,cbus_ack_latch_Snoop1,cbus_ack_latch_Snoop2);
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd0) && (cbus_cmd0== CBUS_WRITE_SNOOP && cbus_cmd1==CBUS_WRITE_SNOOP && cbus_cmd2==CBUS_WRITE_SNOOP)) ##[1:4] (cbus_ack_latch_Snoop0 && cbus_ack_latch_Snoop1 && cbus_ack_latch_Snoop2) |-> (cbus_cmd == CBUS_ENABLE_WRITE) ;
endproperty


a_CBusAck_imm_REnable_3: assert property(CBusAck_imm_REnable(cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_ack0_latch,cbus_ack1_latch,cbus_ack2_latch)) else begin
			$error("AQ: Read enable 3 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_REnable_2: assert property(CBusAck_imm_REnable(cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_ack3_latch,cbus_ack0_latch,cbus_ack1_latch)) else begin
			$error("AQ: Read enable 2 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_REnable_1: assert property(CBusAck_imm_REnable(cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_ack2_latch,cbus_ack3_latch,cbus_ack0_latch)) else begin
			$error("AQ: Read enable 1 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_REnable_0: assert property(CBusAck_imm_REnable(cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_ack1_latch,cbus_ack2_latch,cbus_ack3_latch)) else begin
			$error("AQ: Read enable 0 was not immediately followed by Cbus_acks!: cbus_cmd0 = %0d, cbus_cmd1 = %0d, cbus_cmd2 = %0d, cbus_cmd = %d\n",cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o); 
		  end


a_CBusAck_imm_WEnable_3: assert property(CBusAck_imm_WEnable(cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_ack0_latch,cbus_ack1_latch,cbus_ack2_latch)) else begin
			$error("AQ: Write enable 3 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_WEnable_2: assert property(CBusAck_imm_WEnable(cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_ack3_latch,cbus_ack0_latch,cbus_ack1_latch)) else begin
			$error("AQ: Write enable 2 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_WEnable_1: assert property(CBusAck_imm_WEnable(cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_ack2_latch,cbus_ack3_latch,cbus_ack0_latch)) else begin
			$error("AQ: Write enable 1 was not immediately followed by Cbus_acks!\n"); 
		  end

a_CBusAck_imm_WEnable_0: assert property(CBusAck_imm_WEnable(cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_ack1_latch,cbus_ack2_latch,cbus_ack3_latch)) else begin
			$error("AQ: Write enable 0 was not immediately followed by Cbus_acks!\n"); 
		  end





//***************************************************
//--------------Read snoop & Enable seq--------------
//***************************************************

property RSnoop_Enable(cbus_addr,mbus_cmd,cbus_cmd,cbus_cmd_Snoop0,cbus_cmd_Snoop1,cbus_cmd_Snoop2);
logic [31:0] addr_to_check;
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd_Snoop0) && (cbus_cmd_Snoop0==CBUS_READ_SNOOP && cbus_cmd_Snoop1==CBUS_READ_SNOOP && cbus_cmd_Snoop2==CBUS_READ_SNOOP),addr_to_check=cbus_addr) |-> ##[1:10] (cbus_cmd==CBUS_ENABLE_READ && cbus_addr==addr_to_check && cbus_cmd_Snoop0==CBUS_NOP && cbus_cmd_Snoop1==CBUS_NOP && cbus_cmd_Snoop2==CBUS_NOP);
endproperty


a_RSnoop_Enable_3: assert property(RSnoop_Enable(cbus_addr_o,mbus_cmd3_i,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o)) else begin
			$error("AQ: Read snoop was not followed by write enable 3!\n"); 
		  end

a_RSnoop_Enable_2: assert property(RSnoop_Enable(cbus_addr_o,mbus_cmd2_i,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o)) else begin
			$error("AQ: Read snoop was not followed by write enable 2!\n"); 
		  end

a_RSnoop_Enable_1: assert property(RSnoop_Enable(cbus_addr_o,mbus_cmd1_i,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o)) else begin
			$error("AQ: Read snoop was not followed by write enable 1!\n"); 
		  end

a_RSnoop_Enable_0: assert property(RSnoop_Enable(cbus_addr_o,mbus_cmd0_i,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o)) else begin
			$error("AQ: Read snoop was not followed by write enable 0!\n"); 
		  end

//***************************************************
//-------------Write snoop & Enable seq--------------
//***************************************************

property WSnoop_Enable(cbus_addr,mbus_cmd,cbus_cmd,cbus_cmd_Snoop0,cbus_cmd_Snoop1,cbus_cmd_Snoop2);
logic [31:0] addr_to_check;
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd_Snoop0) && (cbus_cmd_Snoop0==CBUS_WRITE_SNOOP && cbus_cmd_Snoop1==CBUS_WRITE_SNOOP && cbus_cmd_Snoop2==CBUS_WRITE_SNOOP),addr_to_check=cbus_addr) |-> ##[1:10] (cbus_cmd==CBUS_ENABLE_WRITE && cbus_addr==addr_to_check && cbus_cmd_Snoop0==CBUS_NOP && cbus_cmd_Snoop1==CBUS_NOP && cbus_cmd_Snoop2==CBUS_NOP);
endproperty



a_WSnoop_Enable_3: assert property(WSnoop_Enable(cbus_addr_o,mbus_cmd3_i,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o)) else begin
			$error("AQ: Write snoop was not followed by write enable 3!\n"); 
		  end

a_WSnoop_Enable_2: assert property(WSnoop_Enable(cbus_addr_o,mbus_cmd2_i,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o)) else begin
			$error("AQ: Write snoop was not followed by write enable 2!\n"); 
		  end

a_WSnoop_Enable_1: assert property(WSnoop_Enable(cbus_addr_o,mbus_cmd1_i,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o)) else begin
			$error("AQ: Write snoop was not followed by write enable 1!\n"); 
		  end

a_WSnoop_Enable_0: assert property(WSnoop_Enable(cbus_addr_o,mbus_cmd0_i,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o)) else begin
			$error("AQ: Write snoop was not followed by write enable 0!\n"); 
		  end
 
//***************************************************
//---------------Read Burst Snoop seq----------------
//***************************************************

property Rburst_Snoop(mbus_addr,cbus_addr,mbus_cmd,cbus_cmd,cbus_cmd_Snoop0,cbus_cmd_Snoop1,cbus_cmd_Snoop2);
logic [31:0] addr_to_check;
@(posedge clk)
	disable iff (rst)
	(!$stable(mbus_cmd) && (mbus_cmd==MBUS_READ_BROADCAST),addr_to_check=mbus_addr) |-> ##[1:44] (cbus_cmd==CBUS_NOP && cbus_addr==addr_to_check && cbus_cmd_Snoop0==CBUS_READ_SNOOP && cbus_cmd_Snoop1==CBUS_READ_SNOOP && cbus_cmd_Snoop2==CBUS_READ_SNOOP);
endproperty



a_Rburst_snoop_3: assert property(Rburst_Snoop(mbus_addr3_i,cbus_addr_o,mbus_cmd3_i,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o)) else begin
			$error("AQ: Read burst 3 was not followed by a snoop request!\n"); 
		  end

a_Rburst_snoop_2: assert property(Rburst_Snoop(mbus_addr2_i,cbus_addr_o,mbus_cmd2_i,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o)) else begin
			$error("AQ: Read burst 2 was not followed by a snoop request!\n"); 
		  end

a_Rburst_snoop_1: assert property(Rburst_Snoop(mbus_addr1_i,cbus_addr_o,mbus_cmd1_i,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o)) else begin
			$error("AQ: Read burst 1 was not followed by a snoop request!\n"); 
		  end

a_Rburst_snoop_0: assert property(Rburst_Snoop(mbus_addr0_i,cbus_addr_o,mbus_cmd0_i,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o)) else begin
			$error("AQ: Read burst 0 was not followed by a snoop request!\n"); 
		  end

//***************************************************
//------------------Write Burst Snoop seq--------------------
//***************************************************

property Wburst_Snoop(mbus_addr,cbus_addr,mbus_cmd,cbus_cmd,cbus_cmd_Snoop0,cbus_cmd_Snoop1,cbus_cmd_Snoop2);
logic [31:0] addr_to_check;
@(posedge clk)
	disable iff (rst)
	(!$stable(mbus_cmd) && (mbus_cmd==MBUS_WRITE_BROADCAST),addr_to_check=mbus_addr) |-> ##[1:44] (cbus_cmd==CBUS_NOP && cbus_addr==addr_to_check && cbus_cmd_Snoop0==CBUS_WRITE_SNOOP && cbus_cmd_Snoop1==CBUS_WRITE_SNOOP && cbus_cmd_Snoop2==CBUS_WRITE_SNOOP);
endproperty



a_Wburst_snoop_3: assert property(Wburst_Snoop(mbus_addr3_i,cbus_addr_o,mbus_cmd3_i,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o)) else begin
			$error("AQ: Write burst 3 was not followed by a snoop request!\n"); 
		  end

a_Wburst_snoop_2: assert property(Wburst_Snoop(mbus_addr2_i,cbus_addr_o,mbus_cmd2_i,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o,cbus_cmd1_o)) else begin
			$error("AQ: Write burst 2 was not followed by a snoop request!\n"); 
		  end

a_Wburst_snoop_1: assert property(Wburst_Snoop(mbus_addr1_i,cbus_addr_o,mbus_cmd1_i,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o,cbus_cmd0_o)) else begin
			$error("AQ: Write burst 1 was not followed by a snoop request!\n"); 
		  end

a_Wburst_snoop_0: assert property(Wburst_Snoop(mbus_addr0_i,cbus_addr_o,mbus_cmd0_i,cbus_cmd0_o,cbus_cmd1_o,cbus_cmd2_o,cbus_cmd3_o)) else begin
			$error("AQ: Write burst 0 was not followed by a snoop request!\n"); 
		  end

//***************************************************
//------------------Burst ACK seq--------------------
//***************************************************
property burst_ack(mbus_cmd,mbus_ack);
@(posedge clk)
	disable iff (rst)
	(!$stable(mbus_cmd) && (mbus_cmd==MBUS_WRITE_BROADCAST || mbus_cmd ==MBUS_READ_BROADCAST)) |-> ##1 mbus_ack;
endproperty


property NonBurst_NoAck(mbus_cmd,mbus_ack);
@(posedge clk)
	disable iff (rst)
	(mbus_cmd!=MBUS_WRITE_BROADCAST && mbus_cmd !=MBUS_READ_BROADCAST) |-> ##1 !mbus_ack;
endproperty


a_burst_ack_3: 	assert property(burst_ack(mbus_cmd3_i,mbus_ack3_o)) else begin
			$error("AQ: Burst command 3 was not acknowledged!\n"); 
		end

a_burst_ack_2: 	assert property(burst_ack(mbus_cmd2_i,mbus_ack2_o)) else begin
			$error("AQ: Burst command 2 was not acknowledged!\n"); 
		end

a_burst_ack_1: 	assert property(burst_ack(mbus_cmd1_i,mbus_ack1_o)) else begin
			$error("AQ: Burst command 1 was not acknowledged!\n"); 
		end

a_burst_ack_0: 	assert property(burst_ack(mbus_cmd0_i,mbus_ack0_o)) else begin
			$error("AQ: Burst command 0 was not acknowledged!\n"); 
		end

a_NonBurst_NoAck_3: 	assert property(NonBurst_NoAck(mbus_cmd3_i,mbus_ack3_o)) else begin
			$error("AQ: Non-burst command 3 was acknowledged by ISC!\n"); 
		end

a_NonBurst_NoAck_2: 	assert property(NonBurst_NoAck(mbus_cmd2_i,mbus_ack2_o)) else begin
			$error("AQ: Non-burst command 2 was acknowledged by ISC!\n"); 
		end

a_NonBurst_NoAck_1: 	assert property(NonBurst_NoAck(mbus_cmd1_i,mbus_ack1_o)) else begin
			$error("AQ: Non-burst command 1 was acknowledged by ISC!\n"); 
		end

a_NonBurst_NoAck_0: 	assert property(NonBurst_NoAck(mbus_cmd0_i,mbus_ack0_o)) else begin
			$error("AQ: Non-burst command 0 was acknowledged by ISC!\n"); 
		end

//*********************************************************************************************
//---------------------------------------Assumptions-------------------------------------------
//*********************************************************************************************

//***************************************************
//----------------Initial Values---------------------
//***************************************************
property initial_ack(val);
@(posedge clk)
       disable iff (not_initial)
           (val==0);
endproperty

property initial_cmd(val);
@(posedge clk)
       disable iff (not_initial)
           (val==3'b000);
endproperty

assume_initial_cAck3: 	assume property(initial_ack(cbus_ack3_i));
assume_initial_cAck2: 	assume property(initial_ack(cbus_ack2_i));
assume_initial_cAck1: 	assume property(initial_ack(cbus_ack1_i));
assume_initial_cAck0: 	assume property(initial_ack(cbus_ack0_i));

assume_initial_MCmd3: 	assume property(initial_cmd(mbus_cmd3_i));
assume_initial_MCmd2: 	assume property(initial_cmd(mbus_cmd2_i));
assume_initial_MCmd1: 	assume property(initial_cmd(mbus_cmd1_i));
assume_initial_MCmd0: 	assume property(initial_cmd(mbus_cmd0_i));

//***************************************************
//----------------Valid opcode-----------------------
//***************************************************

property ValidOp5(cmd,m_fifo);
@(posedge clk)
           (cmd != 3'b101);
endproperty

property ValidOp6(cmd,m_fifo);
@(posedge clk)
           (cmd != 3'b110);
endproperty

property ValidOp7(cmd,m_fifo);
@(posedge clk)
           (cmd != 3'b111);
endproperty



MBUS3_5: assume property(ValidOp5(mbus_cmd3_i,fifo_full[3]));
MBUS2_5: assume property(ValidOp5(mbus_cmd2_i,fifo_full[2]));
MBUS1_5: assume property(ValidOp5(mbus_cmd1_i,fifo_full[1]));
MBUS0_5: assume property(ValidOp5(mbus_cmd0_i,fifo_full[0]));


MBUS3_6: assume property(ValidOp6(mbus_cmd3_i,fifo_full[3]));
MBUS2_6: assume property(ValidOp6(mbus_cmd2_i,fifo_full[2]));
MBUS1_6: assume property(ValidOp6(mbus_cmd1_i,fifo_full[1]));
MBUS0_6: assume property(ValidOp6(mbus_cmd0_i,fifo_full[0]));


MBUS3_7: assume property(ValidOp7(mbus_cmd3_i,fifo_full[3]));
MBUS2_7: assume property(ValidOp7(mbus_cmd2_i,fifo_full[2]));
MBUS1_7: assume property(ValidOp7(mbus_cmd1_i,fifo_full[1]));
MBUS0_7: assume property(ValidOp7(mbus_cmd0_i,fifo_full[0]));



//***************************************************
//---------------ACK after snoop---------------------
//***************************************************

property AckAfterSnoop(cmd,ack);
@(posedge clk)
           (!$stable(cmd)&&((cmd == CBUS_WRITE_SNOOP)||(cmd == CBUS_READ_SNOOP))) |-> ##[1:4] ack;
endproperty

CBUS3_ack: assume property(AckAfterSnoop(cbus_cmd3_o,cbus_ack3_i));
CBUS2_ack: assume property(AckAfterSnoop(cbus_cmd2_o,cbus_ack2_i));
CBUS1_ack: assume property(AckAfterSnoop(cbus_cmd1_o,cbus_ack1_i));
CBUS0_ack: assume property(AckAfterSnoop(cbus_cmd0_o,cbus_ack0_i));

//***************************************************
//---------------ACK after snoop---------------------
//***************************************************

property NoAckAfterNOP(cmd,ack);
@(posedge clk)
           (cmd == CBUS_NOP) |-> ##1 !ack;
endproperty

CBUS3_Noack: assume property(NoAckAfterNOP(cbus_cmd3_o,cbus_ack3_i));
CBUS2_Noack: assume property(NoAckAfterNOP(cbus_cmd2_o,cbus_ack2_i));
CBUS1_Noack: assume property(NoAckAfterNOP(cbus_cmd1_o,cbus_ack1_i));
CBUS0_Noack: assume property(NoAckAfterNOP(cbus_cmd0_o,cbus_ack0_i));

//***************************************************
//---------------mcmd stable until ack---------------
//***************************************************

property Mcmdstable1(cmd,ack,addr);
@(posedge clk) 
	  ((!$stable(cmd) && cmd==MBUS_WRITE_BROADCAST) |-> ##1 ($stable(cmd) && $stable(addr) && cmd==MBUS_WRITE_BROADCAST)[*1:$] ##0 ack);
endproperty

property Mcmdstable2(cmd,ack,addr);
@(posedge clk) 
	  ((!$stable(cmd) && cmd==MBUS_READ_BROADCAST) |-> ##1 ($stable(cmd) && $stable(addr) && cmd==MBUS_READ_BROADCAST)[*1:$] ##0 ack);

endproperty

property Mcmdstable3(cmd,ack);
logic [2:0] temp;
@(posedge clk) 
	  ((!$stable(ack) && ack==1'b1) |-> $stable(cmd));

endproperty

MBUS3_stable1 : assume property(Mcmdstable1(mbus_cmd3_i,mbus_ack3_o,mbus_addr3_i));
MBUS2_stable1 : assume property(Mcmdstable1(mbus_cmd2_i,mbus_ack2_o,mbus_addr3_i));
MBUS1_stable1 : assume property(Mcmdstable1(mbus_cmd1_i,mbus_ack1_o,mbus_addr3_i));
MBUS0_stable1 : assume property(Mcmdstable1(mbus_cmd0_i,mbus_ack0_o,mbus_addr3_i));

MBUS3_stable2 : assume property(Mcmdstable2(mbus_cmd3_i,mbus_ack3_o,mbus_addr3_i));
MBUS2_stable2 : assume property(Mcmdstable2(mbus_cmd2_i,mbus_ack2_o,mbus_addr3_i));
MBUS1_stable2 : assume property(Mcmdstable2(mbus_cmd1_i,mbus_ack1_o,mbus_addr3_i));
MBUS0_stable2 : assume property(Mcmdstable2(mbus_cmd0_i,mbus_ack0_o,mbus_addr3_i));

MBUS3_stable3 : assume property(Mcmdstable3(mbus_cmd3_i,mbus_ack3_o));
MBUS2_stable3 : assume property(Mcmdstable3(mbus_cmd2_i,mbus_ack2_o));
MBUS1_stable3 : assume property(Mcmdstable3(mbus_cmd1_i,mbus_ack1_o));
MBUS0_stable3 : assume property(Mcmdstable3(mbus_cmd0_i,mbus_ack0_o));


//*********************************************************************************************
//-----------------------------------------Coverage--------------------------------------------
//*********************************************************************************************
//***************************************************
//----------------Coverage-----------------------
//***************************************************

CBUS_ACK3: cover property (@(posedge clk) disable iff (rst) cbus_ack3_i);
CBUS_ACK2: cover property (@(posedge clk) disable iff (rst) cbus_ack2_i);
CBUS_ACK1: cover property (@(posedge clk) disable iff (rst) cbus_ack1_i);
CBUS_ACK0: cover property (@(posedge clk) disable iff (rst) cbus_ack0_i);

MBUS_ACK3: cover property (@(posedge clk) disable iff (rst) mbus_ack3_o);
MBUS_ACK2: cover property (@(posedge clk) disable iff (rst) mbus_ack2_o);
MBUS_ACK1: cover property (@(posedge clk) disable iff (rst) mbus_ack1_o);
MBUS_ACK0: cover property (@(posedge clk) disable iff (rst) mbus_ack0_o);


endmodule

module Wrapper;

   bind mesi_isc MESI_assertions mesi_isc_prop(.clk(clk),
						.rst(rst),
						.mbus_cmd3_i(mbus_cmd3_i),
						.mbus_cmd2_i(mbus_cmd2_i),
						.mbus_cmd1_i(mbus_cmd1_i),
						.mbus_cmd0_i(mbus_cmd0_i),
						.mbus_addr3_i(mbus_addr3_i),
						.mbus_addr2_i(mbus_addr2_i),
						.mbus_addr1_i(mbus_addr1_i),
						.mbus_addr0_i(mbus_addr0_i),
						.cbus_ack3_i(cbus_ack3_i),
						.cbus_ack2_i(cbus_ack2_i),
						.cbus_ack1_i(cbus_ack1_i),
						.cbus_ack0_i(cbus_ack0_i),
						.cbus_addr_o(cbus_addr_o),
						.cbus_cmd3_o(cbus_cmd3_o),
						.cbus_cmd2_o(cbus_cmd2_o),
						.cbus_cmd1_o(cbus_cmd1_o),
						.cbus_cmd0_o(cbus_cmd0_o),
						.mbus_ack3_o(mbus_ack3_o),
						.mbus_ack2_o(mbus_ack2_o),
						.mbus_ack1_o(mbus_ack1_o),
						.mbus_ack0_o(mbus_ack0_o),
						.fifo_full(mesi_isc_inst.mesi_isc_breq_fifos.fifo_status_full_array));

endmodule	
