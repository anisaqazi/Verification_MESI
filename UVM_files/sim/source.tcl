database -open waves -into waves.shm -default
probe -create top -depth all -tasks -functions -uvm -packed 4k -unpacked 16k -all -memories -variables -sc_processes -database waves
run 1 
probe -create $uvm:{uvm_test_top.mesi_env_h} -depth all -tasks -functions -uvm -packed 4k -unpacked 16k -ports
probe -create -shm $uvm:{uvm_test_top.mesi_env_h.master0} -depth all -all
