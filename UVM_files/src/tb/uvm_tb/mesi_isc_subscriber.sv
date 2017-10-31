//`include "uvm_macros.svh"
//import uvm_pkg::*;
//import master_uvc_pkg::*;

//Declaration of TLM analysis imp ports
`uvm_analysis_imp_decl(_master0)
`uvm_analysis_imp_decl(_master1)
`uvm_analysis_imp_decl(_master2)
`uvm_analysis_imp_decl(_master3)

class mesi_isc_subscriber extends uvm_subscriber #(mesi_master_transaction);
    `uvm_component_utils(mesi_isc_subscriber)
    uvm_analysis_imp_master0 #(mesi_master_transaction,mesi_isc_subscriber) master0_ap;
    uvm_analysis_imp_master1 #(mesi_master_transaction,mesi_isc_subscriber) master1_ap;
    uvm_analysis_imp_master2 #(mesi_master_transaction,mesi_isc_subscriber) master2_ap;
    uvm_analysis_imp_master3 #(mesi_master_transaction,mesi_isc_subscriber) master3_ap;

    mesi_master_transaction master0_tx;
    mesi_master_transaction master1_tx;
    mesi_master_transaction master2_tx;
    mesi_master_transaction master3_tx;

    int sample_count = 0;

    covergroup mesi_cg;
	
	//MBus CMD's
    	mbus0_cmd_cp: 	coverpoint master0_tx.mbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE		=	{'d1};
				bins READ		=	{'d2};
				bins WRITE_BROADCAST	=	{'d3};
				bins READ_BROADCAST	=	{'d4};
			}
    	mbus1_cmd_cp: 	coverpoint master1_tx.mbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE		=	{'d1};
				bins READ		=	{'d2};
				bins WRITE_BROADCAST	=	{'d3};
				bins READ_BROADCAST	=	{'d4};
			}
    	mbus2_cmd_cp: 	coverpoint master2_tx.mbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE		=	{'d1};
				bins READ		=	{'d2};
				bins WRITE_BROADCAST	=	{'d3};
				bins READ_BROADCAST	=	{'d4};
			}
    	mbus3_cmd_cp: 	coverpoint master3_tx.mbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE		=	{'d1};
				bins READ		=	{'d2};
				bins WRITE_BROADCAST	=	{'d3};
				bins READ_BROADCAST	=	{'d4};
			}


	//CBus ACK's
	cbus0_ack_cp:	coverpoint master0_tx.cbus_ack	{
				bins NO_ACK		=	{'d0};
				bins ACK		=	{'d1};
			}
	cbus1_ack_cp:	coverpoint master1_tx.cbus_ack	{
				bins NO_ACK		=	{'d0};
				bins ACK		=	{'d1};
			}
	cbus2_ack_cp:	coverpoint master2_tx.cbus_ack	{
				bins NO_ACK		=	{'d0};
				bins ACK		=	{'d1};
			}
	cbus3_ack_cp:	coverpoint master3_tx.cbus_ack	{
				bins NO_ACK		=	{'d0};
				bins ACK		=	{'d1};
			}






	//CBus CMD's
    	cbus0_cmd_cp: 	coverpoint master0_tx.cbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE_SNOOP	=	{'d1};
				bins READ_SNOOP		=	{'d2};
				bins ENABLE_WRITE	=	{'d3};
				bins ENABLE_READ	=	{'d4};
			}
    	cbus1_cmd_cp: 	coverpoint master1_tx.cbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE_SNOOP	=	{'d1};
				bins READ_SNOOP		=	{'d2};
				bins ENABLE_WRITE	=	{'d3};
				bins ENABLE_READ	=	{'d4};
			}
    	cbus2_cmd_cp: 	coverpoint master2_tx.cbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE_SNOOP	=	{'d1};
				bins READ_SNOOP		=	{'d2};
				bins ENABLE_WRITE	=	{'d3};
				bins ENABLE_READ	=	{'d4};
			}
    	cbus3_cmd_cp: 	coverpoint master3_tx.cbus_cmd {
				bins NOP		=	{'d0};
				bins WRITE_SNOOP	=	{'d1};
				bins READ_SNOOP		=	{'d2};
				bins ENABLE_WRITE	=	{'d3};
				bins ENABLE_READ	=	{'d4};
			}

	//MBus ACK's
	mbus0_ack_cp:	coverpoint master0_tx.mbus_ack	{
				bins ACK		=	(0 => 1);
			}
	mbus1_ack_cp:	coverpoint master1_tx.mbus_ack	{
				bins ACK		=	(0 => 1);
			}
	mbus2_ack_cp:	coverpoint master2_tx.mbus_ack	{
				bins ACK		=	(0 => 1);
			}
	mbus3_ack_cp:	coverpoint master3_tx.mbus_ack	{
				bins ACK		=	(0 => 1);
			}

	//MBus ACK's
	m0_snoop_ack_delay_cp:	coverpoint master0_tx.snoop_ack_delay	{
				bins del_1cycle		=	{'d1};
				bins del_2cycle		=	{'d2};
				bins del_3cycle		=	{'d3};
				bins del_4cycle		=	{'d4};
			}
	
	m1_snoop_ack_delay_cp:	coverpoint master1_tx.snoop_ack_delay	{
				bins del_1cycle		=	{'d1};
				bins del_2cycle		=	{'d2};
				bins del_3cycle		=	{'d3};
				bins del_4cycle		=	{'d4};
			}
	
	m2_snoop_ack_delay_cp:	coverpoint master2_tx.snoop_ack_delay	{
				bins del_1cycle		=	{'d1};
				bins del_2cycle		=	{'d2};
				bins del_3cycle		=	{'d3};
				bins del_4cycle		=	{'d4};
			}
	
	m3_snoop_ack_delay_cp:	coverpoint master3_tx.snoop_ack_delay	{
				bins del_1cycle		=	{'d1};
				bins del_2cycle		=	{'d2};
				bins del_3cycle		=	{'d3};
				bins del_4cycle		=	{'d4};
			}

	simultaneous_wr_brdcst_same_location_01: coverpoint {master0_tx.mbus_cmd, master1_tx.mbus_cmd} iff(master0_tx.mbus_addr == master1_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	
	simultaneous_wr_brdcst_same_location_02: coverpoint {master0_tx.mbus_cmd, master2_tx.mbus_cmd} iff(master0_tx.mbus_addr == master2_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	
	simultaneous_wr_brdcst_same_location_03: coverpoint {master0_tx.mbus_cmd, master3_tx.mbus_cmd} iff(master0_tx.mbus_addr == master3_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	
	simultaneous_wr_brdcst_same_location_12: coverpoint {master1_tx.mbus_cmd, master2_tx.mbus_cmd} iff(master1_tx.mbus_addr == master2_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	
	simultaneous_wr_brdcst_same_location_13: coverpoint {master1_tx.mbus_cmd, master3_tx.mbus_cmd} iff(master1_tx.mbus_addr == master3_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	
	simultaneous_wr_brdcst_same_location_23: coverpoint {master2_tx.mbus_cmd, master3_tx.mbus_cmd} iff(master2_tx.mbus_addr == master3_tx.mbus_addr) {
				bins simultaneous_write_to_same_location = {6'b011011};
				bins simultaneous_read_to_same_location = {6'b100100};
	}
	

	mbus0_broadcast_snoop_cross_cp:   	cross mbus0_cmd_cp,m1_snoop_ack_delay_cp,m2_snoop_ack_delay_cp,m3_snoop_ack_delay_cp{
				ignore_bins	master_WRITE	= binsof(mbus0_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus0_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus0_cmd_cp.NOP);
				
				ignore_bins	master1_2cycle	= binsof(m1_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master1_3cycle	= binsof(m1_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master1_4cycle	= binsof(m1_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master2_2cycle	= binsof(m2_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master2_3cycle	= binsof(m2_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master2_4cycle	= binsof(m2_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master3_2cycle	= binsof(m3_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master3_3cycle	= binsof(m3_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master3_4cycle	= binsof(m3_snoop_ack_delay_cp.del_4cycle);
	}

	mbus1_broadcast_snoop_cross_cp:   	cross mbus1_cmd_cp,m0_snoop_ack_delay_cp,m2_snoop_ack_delay_cp,m3_snoop_ack_delay_cp{
				ignore_bins	master_WRITE	= binsof(mbus1_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus1_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus1_cmd_cp.NOP);
				
				ignore_bins	master0_2cycle	= binsof(m0_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master0_3cycle	= binsof(m0_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master0_4cycle	= binsof(m0_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master2_2cycle	= binsof(m2_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master2_3cycle	= binsof(m2_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master2_4cycle	= binsof(m2_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master3_2cycle	= binsof(m3_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master3_3cycle	= binsof(m3_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master3_4cycle	= binsof(m3_snoop_ack_delay_cp.del_4cycle);
	}

	mbus2_broadcast_snoop_cross_cp:   	cross mbus2_cmd_cp,m0_snoop_ack_delay_cp,m1_snoop_ack_delay_cp,m3_snoop_ack_delay_cp{
				ignore_bins	master_WRITE	= binsof(mbus2_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus2_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus2_cmd_cp.NOP);
				
				ignore_bins	master0_2cycle	= binsof(m0_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master0_3cycle	= binsof(m0_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master0_4cycle	= binsof(m0_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master1_2cycle	= binsof(m1_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master1_3cycle	= binsof(m1_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master1_4cycle	= binsof(m1_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master3_2cycle	= binsof(m3_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master3_3cycle	= binsof(m3_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master3_4cycle	= binsof(m3_snoop_ack_delay_cp.del_4cycle);
	}

	mbus3_broadcast_snoop_cross_cp:   	cross mbus3_cmd_cp,m0_snoop_ack_delay_cp,m1_snoop_ack_delay_cp,m2_snoop_ack_delay_cp{
				ignore_bins	master_WRITE	= binsof(mbus3_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus3_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus3_cmd_cp.NOP);
				
				ignore_bins	master0_2cycle	= binsof(m0_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master0_3cycle	= binsof(m0_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master0_4cycle	= binsof(m0_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master1_2cycle	= binsof(m1_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master1_3cycle	= binsof(m1_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master1_4cycle	= binsof(m1_snoop_ack_delay_cp.del_4cycle);

				ignore_bins	master2_2cycle	= binsof(m2_snoop_ack_delay_cp.del_2cycle);
				ignore_bins	master2_3cycle	= binsof(m2_snoop_ack_delay_cp.del_3cycle);
				ignore_bins	master2_4cycle	= binsof(m2_snoop_ack_delay_cp.del_4cycle);
	}	

	mbus_cmd0_mbus_ack0_cross_cp: cross mbus0_cmd_cp, mbus0_ack_cp{
				ignore_bins	master_WRITE	= binsof(mbus0_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus0_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus0_cmd_cp.NOP);

			}

	mbus_cmd1_mbus_ack1_cross_cp: cross mbus1_cmd_cp, mbus1_ack_cp{
				ignore_bins	master_WRITE	= binsof(mbus1_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus1_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus1_cmd_cp.NOP);
			}

	mbus_cmd2_mbus_ack2_cross_cp: cross mbus2_cmd_cp, mbus2_ack_cp{
				ignore_bins	master_WRITE	= binsof(mbus2_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus2_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus2_cmd_cp.NOP);
			}

	mbus_cmd3_mbus_ack3_cross_cp: cross mbus3_cmd_cp, mbus3_ack_cp{
				ignore_bins	master_WRITE	= binsof(mbus3_cmd_cp.WRITE);
				ignore_bins	master_READ	= binsof(mbus3_cmd_cp.READ);
				ignore_bins	master_NOP	= binsof(mbus3_cmd_cp.NOP);
			}

	mbus_cmds_cross_cp:	cross  mbus0_cmd_cp,mbus1_cmd_cp,mbus2_cmd_cp,mbus3_cmd_cp{	

				ignore_bins	master0_WRITE	= binsof(mbus0_cmd_cp.WRITE);
				ignore_bins	master0_READ	= binsof(mbus0_cmd_cp.READ);

				ignore_bins	master1_WRITE	= binsof(mbus1_cmd_cp.WRITE);
				ignore_bins	master1_READ	= binsof(mbus1_cmd_cp.READ);

				ignore_bins	master2_WRITE	= binsof(mbus2_cmd_cp.WRITE);
				ignore_bins	master2_READ	= binsof(mbus2_cmd_cp.READ);

				ignore_bins	master3_WRITE	= binsof(mbus3_cmd_cp.WRITE);
				ignore_bins	master3_READ	= binsof(mbus3_cmd_cp.READ);

			}
		
	 

    endgroup: mesi_cg



    function new(string name, uvm_component parent);
        super.new(name,parent);
	master0_ap=new("master0_ap",this);
        master1_ap=new("master1_ap",this);
        master2_ap=new("master2_ap",this);
        master3_ap=new("master3_ap",this);

        master0_tx=new("master0_tx");
        master1_tx=new("master1_tx");
        master2_tx=new("master2_tx");
        master3_tx=new("master3_tx");

	mesi_cg = new;
    endfunction: new

   
    virtual function void write_master0(mesi_master_transaction t);
	master0_tx = t;
	if(sample_count == 3)
	begin
	  mesi_cg.sample();
	  sample_count = 0;
	end
	else
	begin
	  sample_count++;
	end
    endfunction: write_master0

    virtual function void write_master1(mesi_master_transaction t);
	master1_tx = t;
	if(sample_count == 3)
	begin
	  mesi_cg.sample();
	  sample_count = 0;
	end
	else
	begin
	  sample_count++;
	end
    endfunction: write_master1

    virtual function void write_master2(mesi_master_transaction t);
	master2_tx = t;
	if(sample_count == 3)
	begin
	  mesi_cg.sample();
	  sample_count = 0;
	end
	else
	begin
	  sample_count++;
	end
    endfunction: write_master2

    virtual function void write_master3(mesi_master_transaction t);
	master3_tx = t;
	if(sample_count == 3)
	begin
	  mesi_cg.sample();
	  sample_count = 0;
	end
	else
	begin
	  sample_count++;
	end
    endfunction: write_master3

    virtual function void write(mesi_master_transaction t);
    endfunction: write

endclass: mesi_isc_subscriber
