typedef class mesi_master_config;

class mesi_master_monitor extends uvm_monitor;
    `uvm_component_utils(mesi_master_monitor)

    uvm_analysis_port #(mesi_master_transaction) aport;

    mesi_master_config mesi_master_config_inst;
    virtual mesi_master_if mesi_vi_if;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        mesi_master_config_inst = mesi_master_config::type_id::create("config");
        aport=new("aport",this);
        assert( uvm_config_db #(mesi_master_config)::get(this, "", "mesi_master_config", mesi_master_config_inst) );
        mesi_vi_if = mesi_master_config_inst.mesi_vi_if;

    endfunction: build_phase

    task run_phase(uvm_phase phase);
    	@(posedge mesi_vi_if.clk);
      	forever
      	begin
        	mesi_master_transaction tx;
        	@(posedge mesi_vi_if.clk);
        	tx = mesi_master_transaction::type_id::create("tx");
        	// TODO: Read the values from the virtual interface of dut_vi_in and
        	// assign them to the transaction "tx"
        	tx.mbus_cmd		=	mesi_master_transaction::mbus_cmd_val'(mesi_vi_if.mbus_cmd_wire);
        	tx.mbus_addr		=	mesi_vi_if.mbus_addr_wire;
        	tx.mbus_ack		=	mesi_vi_if.mbus_ack;
		tx.cbus_addr		=	mesi_vi_if.cbus_addr;
		tx.cbus_cmd		=	mesi_vi_if.cbus_cmd;
        	tx.cbus_ack		=	mesi_vi_if.cbus_ack_wire;
	        tx.snoop_ack_delay 	= 	mesi_master_config_inst.snoop_ack_delay;

        	aport.write(tx);
      	end
    endtask: run_phase

endclass: mesi_master_monitor

