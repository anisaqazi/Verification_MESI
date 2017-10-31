`include "master_if.sv"

package master_uvc_pkg;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	typedef virtual mesi_master_if mesi_vi_if;

	`include "master_transaction.sv"
	`include "master_config.sv"
	typedef class mesi_master_agent;
	typedef uvm_sequencer #(mesi_master_transaction) mesi_master_sequencer;

	`include "master_driver.sv"	
	`include "master_monitor.sv"	
	`include "master_agent.sv"
	
	`include "master_seqlib.sv"

endpackage	
