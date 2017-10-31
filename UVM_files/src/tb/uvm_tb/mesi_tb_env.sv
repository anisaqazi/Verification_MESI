//import master_uvc_pkg::*;
//`include "uvm_macros.svh"
//import uvm_pkg::*;


class mesi_tb_env extends uvm_env;
    `uvm_component_utils(mesi_tb_env)

  	mesi_master_agent	master0;
	mesi_master_agent	master1;
	mesi_master_agent	master2;
	mesi_master_agent	master3;

 	mesi_isc_subscriber mesi_isc_subscriber_inst;


    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        master0 = mesi_master_agent::type_id::create("master0",this);
        master1 = mesi_master_agent::type_id::create("master1",this);
        master2 = mesi_master_agent::type_id::create("master2",this);
        master3 = mesi_master_agent::type_id::create("master3",this);

	mesi_isc_subscriber_inst = mesi_isc_subscriber::type_id::create("mesi_isc_subscriber_inst",this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        master0.aport.connect(mesi_isc_subscriber_inst.master0_ap);
        master1.aport.connect(mesi_isc_subscriber_inst.master1_ap);
        master2.aport.connect(mesi_isc_subscriber_inst.master2_ap);
        master3.aport.connect(mesi_isc_subscriber_inst.master3_ap);
        if(master0.aport == null || mesi_isc_subscriber_inst.master0_ap == null)
	begin
	  $display("connect_phase: master0.aport == null || mesi_isc_subscriber_inst.master0_ap == null");
	end
 	else
	begin
	  $display("connect_phase: connection made"); 
	end
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        //TODO: Use this command to set the verbosity of the testbench. By
        //default, it is UVM_MEDIUM
        uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
    endfunction: start_of_simulation_phase

endclass: mesi_tb_env
