class multiple_req_by_all_masters extends base_test;

    `uvm_component_utils(multiple_req_by_all_masters)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	master_config_0.no_of_writes_in_one_write_trans = 3;
	master_config_1.no_of_reads_in_one_read_trans = 3;
	master_config_2.no_of_reads_in_one_read_trans = 2;
	master_config_3.no_of_reads_in_one_read_trans = 2;
    endfunction: build_phase
    
    task run_phase(uvm_phase phase);

        //write_broadcast_seq write_seq;
        write_broadcast_seq write_seq_1, write_seq_2;
	read_broadcast_seq read_seq_1, read_seq_2, read_seq_3;

        //read_seq_1 = read_broadcast_seq::type_id::create("read_seq_1");
        read_seq_2 = read_broadcast_seq::type_id::create("read_seq_2");
        read_seq_3 = read_broadcast_seq::type_id::create("read_seq_3");
        //write_seq = write_broadcast_seq::type_id::create("write_seq");
        write_seq_1 = write_broadcast_seq::type_id::create("write_seq_1");
        write_seq_2 = write_broadcast_seq::type_id::create("write_seq_2");

	phase.raise_objection(this);

	fork
	begin
	  write_seq_1.start(mesi_env_h.master0.mesi_master_sequencer_h);
	end
	begin
	  write_seq_2.start(mesi_env_h.master1.mesi_master_sequencer_h);
	end
	begin
	  read_seq_2.start(mesi_env_h.master2.mesi_master_sequencer_h);
	end
	begin
	  read_seq_3.start(mesi_env_h.master3.mesi_master_sequencer_h);
	end
	join

	phase.drop_objection(this);
    endtask: run_phase     

endclass: multiple_req_by_all_masters
