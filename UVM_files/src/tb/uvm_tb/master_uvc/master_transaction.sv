class mesi_master_transaction extends uvm_sequence_item;
        `uvm_object_utils(mesi_master_transaction)

	parameter
  		CBUS_CMD_WIDTH           = 3,
  		ADDR_WIDTH               = 32,
  		MBUS_CMD_WIDTH           = 3;
    
	typedef enum bit [MBUS_CMD_WIDTH-1:0] {NOP,WR,RD,WR_BROADCAST,RD_BROADCAST} mbus_cmd_val;

	rand mbus_cmd_val 	mbus_cmd; // Main bus command
	rand logic [ADDR_WIDTH-1:0]  	mbus_addr;  // Coherence bus address
	logic                   mbus_ack; 

	logic [2:0]             cbus_cmd;
	logic [ADDR_WIDTH-1:0]	cbus_addr;
	logic                   cbus_ack;

	rand int nop_cycles;	
	rand int cycles_before_write_ack;
	rand int cycles_before_read_ack;

	int snoop_ack_delay;

    	constraint reasonable_nop_cycles
    	{
    	  nop_cycles inside {[12:18]};
    	}

    	constraint reasonable_cycles_before_write_ack
    	{
    	  cycles_before_write_ack inside {[1:4]};
    	}

    	constraint reasonable_cycles_before_read_ack
    	{
    	  cycles_before_read_ack inside {[1:4]};
    	}
	
 
        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={$sformatf("Mbus_cmd = %b, Mbus_addr = %b, Cbus_Ack = %b",mbus_cmd,mbus_addr,cbus_ack)};
        endfunction: convert2string

endclass: mesi_master_transaction

