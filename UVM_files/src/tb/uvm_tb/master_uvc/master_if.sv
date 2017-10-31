interface mesi_master_if;

	parameter
  		CBUS_CMD_WIDTH           = 3,//read snoop, write snoop, read enable, write enable, nop 
  		ADDR_WIDTH               = 32,
  		MBUS_CMD_WIDTH           = 3;//read broadcast, write broadcast, read, write, nop

    	logic           	clk;
    	logic	    		rst;
    	wire [MBUS_CMD_WIDTH-1:0] mbus_cmd_wire; // Main bus command
	// Coherence buses
	wire [ADDR_WIDTH-1:0]  mbus_addr_wire;  // Coherence bus address
	wire                   cbus_ack_wire;  // Coherence bus acknowledge
	   
	// Outputs
	//================================
	
	logic [ADDR_WIDTH-1:0] cbus_addr;  // Coherence bus address. All busses have
	                                      // the same address
	logic [CBUS_CMD_WIDTH-1:0] cbus_cmd; // Coherence bus command
	
	
	logic                  mbus_ack;  // Main bus acknowledge

	logic [MBUS_CMD_WIDTH-1:0] mbus_cmd;
	logic [ADDR_WIDTH-1:0]  mbus_addr;
	logic cbus_ack;

	assign mbus_cmd_wire = (mbus_cmd === 3'bz) ? 3'b0 : mbus_cmd;
	assign mbus_addr_wire = (mbus_addr === 32'hz) ? 32'd0 : mbus_addr;
	assign cbus_ack_wire = (cbus_ack === 1'bz) ? 1'b0 : cbus_ack;


endinterface: mesi_master_if


