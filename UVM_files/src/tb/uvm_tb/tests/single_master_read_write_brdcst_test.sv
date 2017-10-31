class single_master_read_write_brdcst_test extends base_test;

    `uvm_component_utils(single_master_read_write_brdcst_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);

        write_broadcast_seq write_seq;
	read_broadcast_seq read_seq;

	int rand_master_sel = 0;//$urandom_range(0,3);
        int rand_read_write_brdcst_sel = 0;//$urandom_range(0,1);

	if(rand_read_write_brdcst_sel == 0)
	begin
	  read_seq = read_broadcast_seq::type_id::create("read_seq");
	end
	else
	begin
	  write_seq = write_broadcast_seq::type_id::create("write_seq");
	end

	phase.raise_objection(this);

	case(rand_master_sel)
	  0: begin
	       if(read_seq != null)
	       begin
		 $display("test run_phase: read_seq start");
		 read_seq.start(mesi_env_h.master0.mesi_master_sequencer_h);
	       end
	       else if(write_seq != null)
	       begin
		 write_seq.start(mesi_env_h.master0.mesi_master_sequencer_h);
	       end
	     end

	  1: begin
	       if(read_seq != null)
	       begin
		 //$display("test run_phase: read_seq start");
		 read_seq.start(mesi_env_h.master1.mesi_master_sequencer_h);
	       end
	       else if(write_seq != null)
	       begin
		 write_seq.start(mesi_env_h.master1.mesi_master_sequencer_h);
	       end
	     end

	  2: begin
	       if(read_seq != null)
	       begin
		 read_seq.start(mesi_env_h.master2.mesi_master_sequencer_h);
	       end
	       else if(write_seq != null)
	       begin
		 write_seq.start(mesi_env_h.master2.mesi_master_sequencer_h);
	       end
	     end

	  3: begin
	       if(read_seq != null)
	       begin
		 read_seq.start(mesi_env_h.master3.mesi_master_sequencer_h);
	       end
	       else if(write_seq != null)
	       begin
		 write_seq.start(mesi_env_h.master3.mesi_master_sequencer_h);
	       end
	     end
	endcase

	phase.drop_objection(this);
    endtask: run_phase     

endclass: single_master_read_write_brdcst_test
