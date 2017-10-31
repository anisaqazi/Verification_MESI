typedef class mesi_master_config;

class mesi_master_driver extends uvm_driver#(mesi_master_transaction);
    `uvm_component_utils(mesi_master_driver)

    mesi_master_config mesi_master_config_inst;
    virtual mesi_master_if mesi_vi_if;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(mesi_master_config)::get(this, "", "mesi_master_config", mesi_master_config_inst));
       mesi_vi_if = mesi_master_config_inst.mesi_vi_if;
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);

	mesi_vi_if.mbus_cmd <= 'bzzz;
	mesi_vi_if.mbus_addr <= 'hZ;
	mesi_vi_if.cbus_ack <= 'bz;
	
	fork
		begin
			forever
			begin
				mesi_master_transaction tx;
				@(posedge mesi_vi_if.clk);
				$display("master_driver: before seq_item_port.get_next_item");
				seq_item_port.get_next_item(tx);
				$display("master_driver: after seq_item_port.get_next_item");
       				case(tx.mbus_cmd)
					mesi_master_transaction::NOP: this.do_nothing(tx);
					mesi_master_transaction::WR_BROADCAST: this.write_mem(tx);
					mesi_master_transaction::RD_BROADCAST: this.read_mem(tx);
					mesi_master_transaction::WR: this.invalid_write();
					mesi_master_transaction::RD: this.invalid_read();
				endcase
        			seq_item_port.item_done(tx);
			end
		end

		begin
			forever
			begin
				@(posedge mesi_vi_if.clk);
				if(mesi_vi_if.cbus_cmd == 'd1) //write snoop
				begin
				  this.write_snoop_resp(mesi_master_config_inst.snoop_ack_delay);
				end
				else if(mesi_vi_if.cbus_cmd == 'd2) //read snoop
				begin
				  this.read_snoop_resp(mesi_master_config_inst.snoop_ack_delay);
				end
			end
		end
 	join_none


    endtask: run_phase
	
    virtual protected task do_nothing(input mesi_master_transaction tr);    
    	for(int i = 0; i <= tr.nop_cycles - 1; i ++) begin 
		@(posedge mesi_vi_if.clk);
		this.mesi_vi_if.mbus_cmd	<=	tr.mbus_cmd;
		mesi_vi_if.mbus_addr	<=	'd0;
	end //for loop
    endtask: do_nothing 

    virtual protected task invalid_write();  
	this.mesi_vi_if.mbus_cmd	<= 'd1;
	mesi_vi_if.mbus_addr	<=	$random;
	repeat(10) @(posedge mesi_vi_if.clk);
        this.mesi_vi_if.mbus_cmd	<= 3'bz;
	mesi_vi_if.mbus_addr	<=	32'bz;

    endtask: invalid_write

    virtual protected task invalid_read();  
	this.mesi_vi_if.mbus_cmd	<= 'd2;
	mesi_vi_if.mbus_addr	<=	$random;
	repeat(10) @(posedge mesi_vi_if.clk);
        this.mesi_vi_if.mbus_cmd	<= 3'bz;
	mesi_vi_if.mbus_addr	<=	32'bz;

    endtask: invalid_read

    virtual protected task write_mem(input mesi_master_transaction tr);//(input  bit   [3:0] cmd,
                               //output bit [31:0] addr);    
	mesi_vi_if.mbus_cmd	<=	tr.mbus_cmd;
	mesi_vi_if.mbus_addr	<=	tr.mbus_addr;
	wait(mesi_vi_if.mbus_ack);

	wait(mesi_vi_if.mbus_ack == 1'b0);

        if(mesi_master_config_inst.no_of_writes_in_one_write_trans > 1)
        begin
	  repeat(mesi_master_config_inst.no_of_writes_in_one_write_trans - 1)
	  begin
	    wait(mesi_vi_if.mbus_ack == 1'b0);
	    mesi_vi_if.mbus_addr	<= $urandom();
	    wait(mesi_vi_if.mbus_ack);
	    @(posedge mesi_vi_if.clk);
	  end
	end

	mesi_vi_if.mbus_cmd	<= mesi_master_transaction::NOP;

        repeat(mesi_master_config_inst.no_of_writes_in_one_write_trans)
	begin
	  $display("%t: mesi_vi_if.cbus_cmd = %0d",$realtime,mesi_vi_if.cbus_cmd);
       	  while(mesi_vi_if.cbus_cmd != 'd3)  //write enable
       	 	@(posedge mesi_vi_if.clk);
       	  	
          mesi_vi_if.mbus_cmd	<=	mesi_master_transaction::WR; //write access
          repeat(tr.cycles_before_write_ack) @(posedge mesi_vi_if.clk);
          mesi_vi_if.cbus_ack	<=	1'b1;
          mesi_vi_if.mbus_cmd     <=      3'bz;
          mesi_vi_if.mbus_addr	<=      32'bz;
          @(posedge mesi_vi_if.clk)
          mesi_vi_if.cbus_ack	<=	1'bz;
	  @(posedge mesi_vi_if.clk);
	end
	
    endtask: write_mem

    virtual protected task read_mem(input mesi_master_transaction tr);//(input  bit   [3:0] cmd,
                               //output bit [31:0] addr); 
        $display("master_driver: Entered read_mem, tr.mbus_cmd = %s,%b",tr.mbus_cmd,tr.mbus_cmd);   
	mesi_vi_if.mbus_cmd	<=	tr.mbus_cmd;
	mesi_vi_if.mbus_addr	<=	tr.mbus_addr;
	$display("master_driver: Waiting for mbus_ack");
	wait(mesi_vi_if.mbus_ack);
	$display("master_driver: Received mbus_ack");

	wait(mesi_vi_if.mbus_ack == 1'b0);
        if(mesi_master_config_inst.no_of_reads_in_one_read_trans > 1)
        begin
	  repeat(mesi_master_config_inst.no_of_reads_in_one_read_trans - 1)
	  begin
	    wait(mesi_vi_if.mbus_ack == 1'b0);
	    mesi_vi_if.mbus_addr	<= $urandom();
	    wait(mesi_vi_if.mbus_ack);
	    @(posedge mesi_vi_if.clk);
	  end
	end

	mesi_vi_if.mbus_cmd	<= mesi_master_transaction::NOP;

	$display("master_driver: After alppying NOP, waiting for read_en from controller");

        repeat(mesi_master_config_inst.no_of_reads_in_one_read_trans)
	begin
       	  while(mesi_vi_if.cbus_cmd != 'd4)  //read enable
       		@(posedge mesi_vi_if.clk);
           	
          mesi_vi_if.mbus_cmd	<=	mesi_master_transaction::RD;//'d0;
          
          repeat(tr.cycles_before_read_ack) @(posedge mesi_vi_if.clk);
          
          mesi_vi_if.cbus_ack	<=	1'b1;
          mesi_vi_if.mbus_cmd     <=      3'bz;
          mesi_vi_if.mbus_addr	<=      32'bz;
          @(posedge mesi_vi_if.clk)
          mesi_vi_if.cbus_ack	<=	1'bz;
	  @(posedge mesi_vi_if.clk);
	end

    endtask: read_mem

    virtual protected task write_snoop_resp(input int ack_delay);

    	for(int i = 0; i <= ack_delay - 1; i ++) begin 
		@(posedge mesi_vi_if.clk);
	end //for loop

	mesi_vi_if.cbus_ack	<=	'd1;
	@(posedge mesi_vi_if.clk);
	mesi_vi_if.cbus_ack	<=	1'bz;

    endtask: write_snoop_resp

    virtual protected task read_snoop_resp(input int ack_delay);    
    	for(int i = 0; i <= ack_delay - 1; i ++) begin 
		@(posedge mesi_vi_if.clk);
	end //for loop

	mesi_vi_if.cbus_ack	<=	'd1;
	@(posedge mesi_vi_if.clk);
	mesi_vi_if.cbus_ack	<=	1'bz;

    endtask: read_snoop_resp 

endclass: mesi_master_driver

