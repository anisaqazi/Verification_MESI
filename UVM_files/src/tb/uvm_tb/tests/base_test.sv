
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    mesi_master_config master_config_0;
    mesi_master_config master_config_1;
    mesi_master_config master_config_2;
    mesi_master_config master_config_3;
    mesi_tb_env mesi_env_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        master_config_0 = new();
        master_config_1 = new();
        master_config_2 = new();
        master_config_3 = new();

	void'(master_config_0.randomize());
	void'(master_config_1.randomize());
	void'(master_config_2.randomize());
	void'(master_config_3.randomize());

        if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_0", "mesi_vi_if", master_config_0.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_1", "mesi_vi_if", master_config_1.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_2", "mesi_vi_if", master_config_2.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")

	if(!uvm_config_db #(virtual mesi_master_if)::get( this, "master_config_3", "mesi_vi_if", master_config_3.mesi_vi_if))
          `uvm_fatal("NOVIF", "No virtual interface set for dut_in")
        
        mesi_env_h = mesi_tb_env::type_id::create("mesi_env_h", this);

	uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master0*", "mesi_master_config", master_config_0);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master1*", "mesi_master_config", master_config_1);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master2*", "mesi_master_config", master_config_2);
        uvm_config_db #(mesi_master_config)::set(this, "mesi_env_h.master3*", "mesi_master_config", master_config_3);
    endfunction: build_phase

endclass:base_test
