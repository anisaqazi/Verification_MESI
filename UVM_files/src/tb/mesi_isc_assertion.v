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
     mbus_ack0_o
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

reg			cbus_ack0_latch = 0;
reg			cbus_ack1_latch = 0;
reg			cbus_ack2_latch = 0;
reg			cbus_ack3_latch = 0;
reg 			read_write_en_ack = 0;
reg [1:0]		snoop_ack_cnt = 0;
always @(posedge clk)
begin
	if(rst)
	begin 
		cbus_ack0_latch	<=	1'b0;
		cbus_ack1_latch	<=	1'b0;
		cbus_ack2_latch	<=	1'b0;
		cbus_ack3_latch	<=	1'b0;
	end
	else
	begin 
		if(cbus_ack0_i)
		begin
			cbus_ack0_latch	<=	1'b1;
	 	 	$display("cbus_ack0_latch set");
			if(cbus_cmd0_o == CBUS_READ_SNOOP || cbus_cmd0_o == CBUS_WRITE_SNOOP)
			begin
				snoop_ack_cnt++;
			end
			else if(cbus_cmd0_o == CBUS_ENABLE_READ || cbus_cmd0_o == CBUS_ENABLE_WRITE)
			begin
				read_write_en_ack = 1'b1;	
			end
		end
		begin
			if(read_write_en_ack)
			begin
				cbus_ack0_latch <= 	1'b0;
				read_write_en_ack <= 	1'b0;
			end
		end

		if(cbus_ack1_i)
		begin
			cbus_ack1_latch	<=	1'b1;
	 	 	$display("cbus_ack1_latch set");
			if(cbus_cmd1_o == CBUS_READ_SNOOP || cbus_cmd1_o == CBUS_WRITE_SNOOP)
			begin
				snoop_ack_cnt++;
			end
			else if(cbus_cmd1_o == CBUS_ENABLE_READ || cbus_cmd1_o == CBUS_ENABLE_WRITE)
			begin
				read_write_en_ack = 1'b1;	
			end
		end
		else
		begin
			if(read_write_en_ack)
			begin
				cbus_ack1_latch <= 	1'b0;
				read_write_en_ack <= 	1'b0;
			end
		end


		if(cbus_ack2_i)
		begin
			cbus_ack2_latch	<=	1'b1;
	 	 	$display("cbus_ack2_latch set");
			if(cbus_cmd2_o == CBUS_READ_SNOOP || cbus_cmd2_o == CBUS_WRITE_SNOOP)
			begin
				snoop_ack_cnt++;
			end
			else if(cbus_cmd2_o == CBUS_ENABLE_READ || cbus_cmd2_o == CBUS_ENABLE_WRITE)
			begin
				read_write_en_ack = 1'b1;	
			end
		end
		begin
			if(read_write_en_ack)
			begin
				cbus_ack2_latch <= 	1'b0;
				read_write_en_ack <= 	1'b0;
			end
		end


		if(cbus_ack3_i)
		begin
			cbus_ack3_latch	<=	1'b1;
	 	 	$display("cbus_ack3_latch set");
			if(cbus_cmd3_o == CBUS_READ_SNOOP || cbus_cmd3_o == CBUS_WRITE_SNOOP)
			begin
				snoop_ack_cnt++;
			end
			else if(cbus_cmd3_o == CBUS_ENABLE_READ || cbus_cmd3_o == CBUS_ENABLE_WRITE)
			begin
				read_write_en_ack = 1'b1;	
			end
		end
		begin
			if(read_write_en_ack)
			begin
				cbus_ack3_latch <= 	1'b0;
				read_write_en_ack <= 	1'b0;
			end
		end

	 	if(snoop_ack_cnt == 2'd3)
		begin
		  cbus_ack0_latch       <=	1'b0;
	          cbus_ack1_latch	<=	1'b0;
		  cbus_ack2_latch	<=	1'b0;
		  cbus_ack3_latch	<=	1'b0;
		  snoop_ack_cnt         <=      2'd0;
		end


	end
	
end

//**********************************************************
//-----------All ack immediately followed by Enable---------
//**********************************************************
property CBusAck_imm_REnable(cbus_cmd,cbus_cmd0,cbus_cmd1,cbus_cmd2,cbus_ack_latch_Snoop0,cbus_ack_latch_Snoop1,cbus_ack_latch_Snoop2);
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd0) && (cbus_cmd0== CBUS_READ_SNOOP && cbus_cmd1==CBUS_READ_SNOOP && cbus_cmd2==CBUS_READ_SNOOP)) ##[1:$] (cbus_ack_latch_Snoop0 && cbus_ack_latch_Snoop1 && cbus_ack_latch_Snoop2) |-> ##1 (cbus_cmd == CBUS_ENABLE_READ) ;
endproperty

property CBusAck_imm_WEnable(cbus_cmd,cbus_cmd0,cbus_cmd1,cbus_cmd2,cbus_ack_latch_Snoop0,cbus_ack_latch_Snoop1,cbus_ack_latch_Snoop2);
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd0) && (cbus_cmd0== CBUS_WRITE_SNOOP && cbus_cmd1==CBUS_WRITE_SNOOP && cbus_cmd2==CBUS_WRITE_SNOOP)) ##[1:$] (cbus_ack_latch_Snoop0 && cbus_ack_latch_Snoop1 && cbus_ack_latch_Snoop2) |-> ##1 (cbus_cmd == CBUS_ENABLE_WRITE) ;
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
//---------------Enable until CBUS ack---------------
//***************************************************
property Enable_CBusAck(cbus_cmd,cbus_ack);
@(posedge clk)
	disable iff (rst)
	(!$stable(cbus_cmd) && (cbus_cmd== CBUS_ENABLE_READ || cbus_cmd==CBUS_ENABLE_WRITE)) |-> ##1 $stable(cbus_cmd)[*0:$] ##1 cbus_ack;
endproperty

a_Enable_CBusAck_3: assert property(Enable_CBusAck(cbus_cmd3_o,cbus_ack3_i)) else begin
			$error("AQ: Master 3 enable not held until acknowledged!\n"); 
		  end
  
a_Enable_CBusAck_2: assert property(Enable_CBusAck(cbus_cmd2_o,cbus_ack2_i)) else begin
			$error("AQ: Master 2 enable not held until acknowledged!\n"); 
		  end
  
a_Enable_CBusAck_1: assert property(Enable_CBusAck(cbus_cmd1_o,cbus_ack1_i)) else begin
			$error("AQ: Master 1 enable not held until acknowledged!\n"); 
		  end
  
a_Enable_CBusAck_0: assert property(Enable_CBusAck(cbus_cmd0_o,cbus_ack0_i)) else begin
			$error("AQ: Master 0 enable not held until acknowledged!\n"); 
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
	(!$stable(mbus_cmd) && (mbus_cmd==MBUS_WRITE_BROADCAST),addr_to_check=mbus_addr) |-> ##[1:100] (cbus_cmd==CBUS_NOP && cbus_addr==addr_to_check && cbus_cmd_Snoop0==CBUS_WRITE_SNOOP && cbus_cmd_Snoop1==CBUS_WRITE_SNOOP && cbus_cmd_Snoop2==CBUS_WRITE_SNOOP);
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

endmodule	
