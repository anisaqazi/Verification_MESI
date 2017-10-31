class mesi_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(mesi_virtual_sequencer)

    master_uvc_pkg::mesi_master_sequencer master0_seqr;
    master_uvc_pkg::mesi_master_sequencer master1_seqr;
    master_uvc_pkg::mesi_master_sequencer master2_seqr;
    master_uvc_pkg::mesi_master_sequencer master3_seqr;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

endclass : mesi_virtual_sequencer
