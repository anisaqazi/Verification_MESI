1. cd sim
2. Update the path 'BASE_DIR' in Makefile
3. make clean
4. To run test in gui mode:  make run_test_gui TEST=<test_name>
   To run regression tests:
   make run_regress_1




Below is the list of tests added to this project:
1.  multiple_req_by_all_masters
2.  other_masters_req_when_one_master_sends_read_write
3.  simultaneous_brdcst_req_test
4.  single_master_read_write_brdcst_test
5.  invalid_read_write_seq_test
6.  constrained_config_addr_test
