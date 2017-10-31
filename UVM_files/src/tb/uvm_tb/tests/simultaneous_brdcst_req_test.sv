class simultaneous_brdcst_req_test extends base_test;

    `uvm_component_utils(simultaneous_brdcst_req_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);

        write_broadcast_seq write_seq_m1;
	read_broadcast_seq read_seq_m1;
        write_broadcast_seq write_seq_m2;
	read_broadcast_seq read_seq_m2;

	int rand_master_sel_1 = $urandom_range(0,3);
	int rand_master_sel_2 = $urandom_range(0,3);


        int rand_read_write_brdcst_sel_m1 = $urandom_range(0,1);
        int rand_read_write_brdcst_sel_m2 = $urandom_range(0,1);

	int random_delay_bw_brdcst_req = $urandom_range(0,5);

	if(rand_master_sel_1 == rand_master_sel_2)
        begin
	  if(rand_master_sel_2 < 3)
	  begin
	    rand_master_sel_2 = rand_master_sel_2 + 1;
	  end
	  else 
	  begin
	    rand_master_sel_2 = 0;
	  end
	end

	if(rand_read_write_brdcst_sel_m1 == 0)
	begin
	  read_seq_m1 = read_broadcast_seq::type_id::create("read_seq_m1");
	end
	else
	begin
	  write_seq_m1 = write_broadcast_seq::type_id::create("write_seq_m1");
	end

	if(rand_read_write_brdcst_sel_m2 == 0)
	begin
	  read_seq_m2 = read_broadcast_seq::type_id::create("read_seq_m2");
	end
	else
	begin
	  write_seq_m2 = write_broadcast_seq::type_id::create("write_seq_m2");
	end

	phase.raise_objection(this);

	fork
	begin
  	  case(rand_master_sel_1)
  	    0: begin
  	         if(read_seq_m1 != null)
  	         begin
  	  	 $display("test run_phase: read_seq start");
  	  	 read_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m1 != null)
  	         begin
  	  	 write_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    1: begin
  	         if(read_seq_m1 != null)
  	         begin
  	  	 //$display("test run_phase: read_seq start");
  	  	 read_seq_m1.start(mesi_env_h.master1.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m1 != null)
  	         begin
  	  	 write_seq_m1.start(mesi_env_h.master1.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    2: begin
  	         if(read_seq_m1 != null)
  	         begin
  	  	 read_seq_m1.start(mesi_env_h.master2.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m1 != null)
  	         begin
  	  	 write_seq_m1.start(mesi_env_h.master2.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    3: begin
  	         if(read_seq_m1 != null)
  	         begin
  	  	 read_seq_m1.start(mesi_env_h.master3.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m1 != null)
  	         begin
  	  	 write_seq_m1.start(mesi_env_h.master3.mesi_master_sequencer_h);
  	         end
  	       end
  	  endcase
	end

	begin
	  @(posedge top.clk);
	  repeat(random_delay_bw_brdcst_req)
	  @(posedge top.clk);
  	  case(rand_master_sel_2)
  	    0: begin
  	         if(read_seq_m2 != null)
  	         begin
  	  	 $display("test run_phase: read_seq start");
  	  	 read_seq_m2.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m2 != null)
  	         begin
  	  	 write_seq_m2.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    1: begin
  	         if(read_seq_m2 != null)
  	         begin
  	  	 //$display("test run_phase: read_seq start");
  	  	 read_seq_m2.start(mesi_env_h.master1.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m2 != null)
  	         begin
  	  	 write_seq_m2.start(mesi_env_h.master1.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    2: begin
  	         if(read_seq_m2 != null)
  	         begin
  	  	 read_seq_m2.start(mesi_env_h.master2.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m2 != null)
  	         begin
  	  	 write_seq_m2.start(mesi_env_h.master2.mesi_master_sequencer_h);
  	         end
  	       end
  
  	    3: begin
  	         if(read_seq_m2 != null)
  	         begin
  	  	 read_seq_m2.start(mesi_env_h.master3.mesi_master_sequencer_h);
  	         end
  	         else if(write_seq_m2 != null)
  	         begin
  	  	 write_seq_m2.start(mesi_env_h.master3.mesi_master_sequencer_h);
  	         end
  	       end
  	  endcase
	end
        join

	//#55;

	phase.drop_objection(this);
    endtask: run_phase     

endclass: simultaneous_brdcst_req_test
