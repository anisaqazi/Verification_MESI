class other_masters_req_when_one_master_sends_read_write extends base_test;

    `uvm_component_utils(other_masters_req_when_one_master_sends_read_write)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);

        write_broadcast_seq write_seq_m1;
	read_broadcast_seq read_seq_m1;
        write_broadcast_seq write_seq_m2;
	read_broadcast_seq read_seq_m2;
	write_broadcast_seq write_seq_m3;
	read_broadcast_seq read_seq_m4;

        int rand_read_write_brdcst_sel_m1 = $urandom_range(0,1);
        int rand_read_write_brdcst_sel_m2 = $urandom_range(0,1);

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

	write_seq_m3 = write_broadcast_seq::type_id::create("write_seq_m3");
        read_seq_m4 = read_broadcast_seq::type_id::create("read_seq_m4");

	phase.raise_objection(this);

	fork
	begin
  	  if(read_seq_m1 != null)
  	  begin
  	    $display("test run_phase: read_seq start");
  	    read_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	    read_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	  end
  	  else if(write_seq_m1 != null)
  	  begin
  	    write_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	    write_seq_m1.start(mesi_env_h.master0.mesi_master_sequencer_h);
  	  end
	end

	begin
          wait(top.mesi_if_master0.cbus_cmd == 3'd4 || top.mesi_if_master0.cbus_cmd == 3'd3);
  
          if(read_seq_m2 != null)
          begin
            read_seq_m2.start(mesi_env_h.master1.mesi_master_sequencer_h);
          end
          else if(write_seq_m2 != null)
          begin
            write_seq_m2.start(mesi_env_h.master1.mesi_master_sequencer_h);
          end
        end

	begin
	  wait(top.mesi_if_master0.cbus_cmd == 3'd4 || top.mesi_if_master0.cbus_cmd == 3'd3);
          @(top.mesi_if_master0.clk);
          write_seq_m3.start(mesi_env_h.master2.mesi_master_sequencer_h);
	end

	begin
	  wait(top.mesi_if_master0.cbus_cmd == 3'd4 || top.mesi_if_master0.cbus_cmd == 3'd3);
	  @(top.mesi_if_master0.clk);
	  @(top.mesi_if_master0.clk);
          read_seq_m4.start(mesi_env_h.master3.mesi_master_sequencer_h);
	end
        join

	//#55;

	phase.drop_objection(this);
    endtask: run_phase     

endclass: other_masters_req_when_one_master_sends_read_write
