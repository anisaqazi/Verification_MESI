class write_broadcast_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(write_broadcast_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx = mesi_master_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::WR_BROADCAST;});
            finish_item(tx);
        endtask: body
endclass: write_broadcast_seq

class read_broadcast_seq extends uvm_sequence #(mesi_master_transaction);
        `uvm_object_utils(read_broadcast_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            mesi_master_transaction tx;
            tx=mesi_master_transaction::type_id::create("tx");
	    $display("read_broadcast_seq: Inside body, before start_item");
            start_item(tx);
            assert(tx.randomize() with {tx.mbus_cmd == mesi_master_transaction::RD_BROADCAST;})
            finish_item(tx);
	    $display("read_broadcast_seq: Inside body, after finish_item");
        endtask: body

endclass: read_broadcast_seq
