`include "uvm_macros.svh"

class mesi_master_config extends uvm_object;

    `uvm_object_utils(mesi_master_config)

    virtual mesi_master_if mesi_vi_if;

    rand int snoop_ack_delay;
    int no_of_writes_in_one_write_trans = 1;
    int no_of_reads_in_one_read_trans = 1;

    constraint reasonable_snoop_ack_delay
    {
      snoop_ack_delay inside {[1:4]};
    }

endclass: mesi_master_config

