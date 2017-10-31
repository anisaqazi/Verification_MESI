class constrained_master_config extends mesi_master_config;

  `uvm_object_utils(constrained_master_config)

  constraint reasonable_snoop_ack_delay {
    snoop_ack_delay == 'd1;
  }

endclass : constrained_master_config

class constrained_write_broadcast_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(constrained_write_broadcast_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx = mesi_master_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::WR_BROADCAST; tx.mbus_addr == 32'hF11F0E36;});
            finish_item(tx);
        endtask: body

endclass: constrained_write_broadcast_seq

class constrained_read_broadcast_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(constrained_read_broadcast_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx = mesi_master_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::RD_BROADCAST; tx.mbus_addr == 32'hF11F0E36;});
            finish_item(tx);
        endtask: body

endclass: constrained_read_broadcast_seq

class constrained_config_addr_test extends uvm_test;

    `uvm_component_utils(constrained_config_addr_test)

    constrained_master_config master_config_0;
    constrained_master_config master_config_1;
    constrained_master_config master_config_2;
    constrained_master_config master_config_3;
    mesi_tb_env mesi_env_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);

	master_config_0 = new();
        master_config_1 = new();
        master_config_2 = new();
        master_config_3 = new();

	void'(master_config_0.randomize());
	void'(master_config_1.randomize());
	void'(master_config_2.randomize());
	void'(master_config_3.randomize());

        if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_0", "mesi_vi_if", master_config_0.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_1", "mesi_vi_if", master_config_1.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_2", "mesi_vi_if", master_config_2.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_3", "mesi_vi_if", master_config_3.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")
        
        mesi_env_h = mesi_tb_env::type_id::create("mesi_env_h", this);

	uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master0*", "mesi_master_config", master_config_0);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master1*", "mesi_master_config", master_config_1);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master2*", "mesi_master_config", master_config_2);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master3*", "mesi_master_config", master_config_3);

    endfunction: build_phase
    
    task run_phase(uvm_phase phase);

	constrained_read_broadcast_seq read_seq_1;
	//constrained_read_broadcast_seq read_seq_2;
	//constrained_read_broadcast_seq read_seq_3;
	//constrained_read_broadcast_seq read_seq_4;

        constrained_write_broadcast_seq write_seq_1;
        constrained_write_broadcast_seq write_seq_2;
        constrained_write_broadcast_seq write_seq_3;
        constrained_write_broadcast_seq write_seq_4;

	write_seq_1 = constrained_write_broadcast_seq::type_id::create("write_seq_1");
	write_seq_2 = constrained_write_broadcast_seq::type_id::create("write_seq_2");
	write_seq_3 = constrained_write_broadcast_seq::type_id::create("write_seq_3");
	write_seq_4 = constrained_write_broadcast_seq::type_id::create("write_seq_4");
	
	read_seq_1 = constrained_read_broadcast_seq::type_id::create("read_seq_1");
	//read_seq_2 = constrained_read_broadcast_seq::type_id::create("read_seq_2");
	//read_seq_3 = constrained_read_broadcast_seq::type_id::create("read_seq_3");
	//read_seq_4 = constrained_read_broadcast_seq::type_id::create("read_seq_4");

	phase.raise_objection(this);

 	fork
	  begin
	    //write_seq_1.start(mesi_env_h.master0.mesi_master_sequencer_h);
	    read_seq_1.start(mesi_env_h.master0.mesi_master_sequencer_h);
	  end

	  begin
	    write_seq_2.start(mesi_env_h.master1.mesi_master_sequencer_h);
	    //read_seq_2.start(mesi_env_h.master1.mesi_master_sequencer_h);
	  end

	  begin
	    write_seq_3.start(mesi_env_h.master2.mesi_master_sequencer_h);
	    //read_seq_3.start(mesi_env_h.master2.mesi_master_sequencer_h);
	  end

	  begin
	    write_seq_4.start(mesi_env_h.master3.mesi_master_sequencer_h);
	    //read_seq_4.start(mesi_env_h.master3.mesi_master_sequencer_h);
	  end
	join

	phase.drop_objection(this);
    endtask: run_phase     

endclass: constrained_config_addr_test
