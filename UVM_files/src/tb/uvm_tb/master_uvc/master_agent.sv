//typedef uvm_sequencer #(mesi_master_transaction) mesi_master_sequencer;


class mesi_master_agent extends uvm_agent;
    `uvm_component_utils(mesi_master_agent)

    uvm_analysis_port #(mesi_master_transaction) aport;

    mesi_master_sequencer mesi_master_sequencer_h;
    mesi_master_driver mesi_master_driver_h;
    mesi_master_monitor mesi_master_monitor_h;
    
    virtual mesi_master_if mesi_vi_if;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        aport=new("aport",this);
        mesi_master_sequencer_h=mesi_master_sequencer::type_id::create("mesi_master_sequencer_h",this);
        mesi_master_driver_h=mesi_master_driver::type_id::create("mesi_master_driver_h",this);
        mesi_master_monitor_h=mesi_master_monitor::type_id::create("mesi_master_monitor_h",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        mesi_master_driver_h.seq_item_port.connect(mesi_master_sequencer_h.seq_item_export);
        mesi_master_monitor_h.aport.connect(aport);
    endfunction: connect_phase

endclass: mesi_master_agent


