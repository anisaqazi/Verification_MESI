class invalid_read_write_seq_test extends base_test;

    `uvm_component_utils(invalid_read_write_seq_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    class invalid_write_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(invalid_write_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx = mesi_master_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::WR;});
            finish_item(tx);
        endtask: body
    endclass: invalid_write_seq

    class invalid_read_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(invalid_read_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx = mesi_master_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::RD;});
            finish_item(tx);
        endtask: body
    endclass: invalid_read_seq
    
    task run_phase(uvm_phase phase);

        write_broadcast_seq write_seq;
	read_broadcast_seq read_seq;
	invalid_write_seq invalid_wr_seq;
	invalid_read_seq invalid_rd_seq;

	read_seq = read_broadcast_seq::type_id::create("read_seq");
	write_seq = write_broadcast_seq::type_id::create("write_seq");
	invalid_wr_seq = invalid_write_seq::type_id::create("invalid_wr_seq");
	invalid_rd_seq = invalid_read_seq::type_id::create("invalid_rd_seq");

	phase.raise_objection(this);

        fork
	begin
	  repeat(6) @(top.clk);
	  invalid_wr_seq.start(mesi_env_h.master0.mesi_master_sequencer_h);
	end
	begin
	  read_seq.start(mesi_env_h.master1.mesi_master_sequencer_h);
	end
        begin
	  repeat(15) @(top.clk);
	  invalid_rd_seq.start(mesi_env_h.master2.mesi_master_sequencer_h);
	end
	begin
	  write_seq.start(mesi_env_h.master3.mesi_master_sequencer_h);
	end
	join

	phase.drop_objection(this);
    endtask: run_phase     

endclass: invalid_read_write_seq_test
