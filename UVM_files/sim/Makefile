# Filename: Makefile
#

.PHONY: help
help:
	@printf "Usage: make [PARAM=VALUE] ... target\n"
	@printf "\n"
	@printf "Valid parameters:\n"
	@printf "    NUM_BLOCKS - Number of AES blocks (default: 1)\n"
	@printf "    NUM_VECS   - Number of test vectors per instance (default: 1000)\n"
	@printf "\n"
	@printf "Miscellaneous targets:\n"
	@printf "    help  - Display this help message\n"
	@printf "    clean - Clean intermediate files\n"
	@printf "\n"
	@printf "Cadence Incisive targets:\n"
	@printf "    inca-elab - Elaborate the design\n"
	@printf "    inca-tgz  - Build gzipped tarball\n"
	@printf "    inca-sim  - Simulate the design\n"
	@printf "    inca-gui  - Debug with the SimVision GUI\n"
	@printf "\n"
	@printf "Synopsys VCS targets:\n"
	@printf "    vcs-elab  - Elaborate the design\n"
	@printf "    vcs-tgz   - Build gzipped tarball\n"
	@printf "    vcs-sim   - Simulate the design\n"
	@printf "    vcs-gui   - Debug with VCS GUI\n"



# Unconditional target
FORCE:

BASE_DIR:= /home/ecelrc/students/aqazi/Verif/Project/Project_submission/UVM_files/src

VLOG_RTL_FILES := \
    $(BASE_DIR)/rtl/mesi_isc.v \
    $(BASE_DIR)/rtl/mesi_isc_broad.v \
    $(BASE_DIR)/rtl/mesi_isc_broad_cntl.v \
    $(BASE_DIR)/rtl//mesi_isc_breq_fifos_cntl.v \
    $(BASE_DIR)/rtl/mesi_isc_breq_fifos.v \
    $(BASE_DIR)/rtl/mesi_isc_basic_fifo.v

VLOG_TB_FILES := \
    $(BASE_DIR)/tb/mesi_isc_tb.v \
    $(BASE_DIR)/tb/mesi_isc_assertion.v 

SV_UVM_FILES := \
    $(BASE_DIR)/tb/uvm_tb/master_uvc/master_uvc.sv \
    $(BASE_DIR)/tb/uvm_tb/top.sv \
    $(BASE_DIR)/tb/mesi_isc_assertion.v
	 
TEST := base_test

SRC := \
    $(VLOG_RTL_FILES) 
#    $(VLOG_TB_FILES) 

# Cadence Incisive Enterprise targets
export INCA_64BIT := true


VLOG := vlog
VLOG_FLAGS := +cover -sv +incdir+$(UVM_HOME)/src
TOP := top

IRUN := irun
IRUN_ELAB_FLAGS := -uvm -sv -access +rwc -uvmhome $(UVM_HOME) -incdir $(BASE_DIR)/rtl -incdir $(BASE_DIR)/tb -incdir $(BASE_DIR)/tb/uvm_tb -incdir $(BASE_DIR)/tb/uvm_tb/master_uvc -incdir $(BASE_DIR)/tb/uvm_tb/tests -cflags '-I$(BASE_DIR)/rtl -I$(BASE_DIR)/tb' -coverage functional -covdut top -covoverwrite 
IRUN_ELAB_FILES := $(SRC) $(SV_UVM_FILES)
IRUN_SIM_FLAGS := -nowarn WSEM2009
IRUN_SIM_CMD := irun-sim.cmd

RUN_GUI_MODELSIM: $(SRC) $(SV_UVM_FILES)
	vlib work
	$(VLOG) $(SRC) $(SV_UVM_FILES) $(VLOG_FLAGS) 
	vsim -voptargs="+acc" -gui $(TOP)

RUN_GUI: $(SRC) 
	$(IRUN) -gui -top $(TOP) -svseed 1 +UVM_TESTNAME=${TEST} -input source.tcl -l irun.elab.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) 
	#$(IRUN) -gui -top $(TOP) -svseed 1 +UVM_TESTNAME=single_master_read_write_brdcst_test -input source.tcl -l irun.elab.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func1.cov

RUN_REGRESS_1: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func1.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func2.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func3.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func4.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func5.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func6.cov

RUN_REGRESS_2: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func7.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func8.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func9.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func10.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func11.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func12.cov

RUN_REGRESS_3: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func13.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func14.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func15.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func16.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func17.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func18.cov

RUN_REGRESS_4: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func19.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func20.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func21.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func22.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func23.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func24.cov

RUN_REGRESS_5: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func25.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func26.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func27.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func28.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func29.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func30.cov

RUN_REGRESS_6: $(SRC) 
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=single_master_read_write_brdcst_test -input source_regress.tcl -l log/irun1.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func31.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=simultaneous_brdcst_req_test -input source_regress.tcl -l log/irun2.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func32.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=other_masters_req_when_one_master_sends_read_write -input source_regress.tcl -l log/irun3.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func33.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=multiple_req_by_all_masters -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func34.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=invalid_read_write_seq_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func35.cov
	$(IRUN) -top $(TOP) -svseed random +UVM_TESTNAME=constrained_config_addr_test -input source_regress.tcl -l log/irun4.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES) -covtest mycov_func36.cov

RUN_BATCH: $(SRC) 
	$(IRUN) -l irun.elab.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES)

INCA_libs: $(SRC) 
	$(IRUN) -elaborate -l irun.elab.log $(IRUN_ELAB_FLAGS) $(IRUN_ELAB_FILES)

INCA_libs.tar.gz: INCA_libs
	@printf "INCA_64BIT=true $(IRUN) -R -l irun.sim.log $(IRUN_SIM_FLAGS)\n" > $(IRUN_SIM_CMD)
	@chmod +x $(IRUN_SIM_CMD)
	tar -czf $@ $^ $(IRUN_SIM_CMD)
	@rm -f $(IRUN_SIM_CMD)

.PHONY: run_modelsim
run_modelsim: RUN_GUI_MODELSIM

.PHONY: run_test_gui
run_test_gui: RUN_GUI

.PHONY: run_regress_1
run_regress_1: RUN_REGRESS_1

.PHONY: run_regress_2
run_regress_2: RUN_REGRESS_2

.PHONY: run_regress_3
run_regress_3: RUN_REGRESS_3

.PHONY: run_regress_4
run_regress_4: RUN_REGRESS_4

.PHONY: run_regress_5
run_regress_5: RUN_REGRESS_5

.PHONY: run_regress_6
run_regress_6: RUN_REGRESS_6

.PHONY: run_test_batch
run_test_batch: RUN_BATCH


.PHONY: inca-elab
inca-elab: INCA_libs

.PHONY: inca-tgz
inca-tgz: INCA_libs.tar.gz

.PHONY: inca-sim
inca-sim: INCA_libs
	$(IRUN) -R -l irun.sim.log  $(IRUN_SIM_FLAGS)

.PHONY: inca-gui
inca-gui: INCA_libs
	$(IRUN) -R -l irun.sim.log -gui $(IRUN_SIM_FLAGS)

.PHONY: clean
clean:
	rm -rf .simvision INCA_libs* waves.shm
	rm -f irun.*.log irun.key

.PHONY: clean_modelsim
clean_modelsim:
	vdel -all
